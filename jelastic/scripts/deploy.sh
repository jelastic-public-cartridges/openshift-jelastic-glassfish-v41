#!/bin/bash

# Simple deploy and undeploy scenarios for Glassfish4

. /etc/jelastic/environment

WGET=$(which wget);
AS_ADMIN="/opt/repo/versions/${Version}/bin/asadmin";
PASS_FILE="/opt/repo/.gfpass";
ADMIN_USER="jelastic";
include output;

function _runAsadminCmd(){
        local cmd=$@;
        [ -f $PASS_FILE ] && {
                local temp_file=`mktemp /tmp/pass.XXXXXXX`;
                echo -n "AS_ADMIN_PASSWORD=" > $temp_file;
                cat $PASS_FILE >> $temp_file;
                $AS_ADMIN -u $ADMIN_USER -W $temp_file $cmd >> $ACTIONS_LOG 2>&1;
                local result=$?;
                rm $temp_file;
                return $result;
        } || { $AS_ADMIN $cmd > /dev/null 2>&1; };
}

function ensureFileCanBeDownloaded(){
    local resource_url=$1;
    resource_data_dize=$($CURL -s --head $resource_url | $GREP "Content-Length" | $AWK -F ":" '{ print $2 }'| $SED 's/[^0-9]//g');
    freebytesleft=$(( 1024 *  $(df  | $GREP "/$" | $AWK '{ print $4 }' | head -n 1)-1024*1024));
    [ -z ${resource_data_dize} ] && return 0;
    [ ${resource_data_dize} -lt  ${freebytesleft} ] || { writeJSONResponseErr "result=>4075" "message=>No free diskspace"; die -q; }
    return 0;
}

function getPackageName() {
    if [ -f "$package_url" ]; then
        package_name="$package_url";
    elif [[ "${package_url}" =~ file://* ]]; then
        package_name="${package_url:7}"
        [ -f "$package_name" ] || { writeJSONResponseErr "result=>4078" "message=>Error loading file from URL"; die -q; }
    else
        ensureFileCanBeDownloaded $package_url;
        $WGET --no-check-certificate --content-disposition --directory-prefix="$download_dir" $package_url >> $ACTIONS_LOG 2>&1 || { writeJSONResponseErr "result=>4078" "message=>Error loading file from URL"; die -q; }
        package_name="${download_dir}/$(ls ${download_dir})";
        [ ! -s "$package_name" ] && {
            set -f
            rm -f "${package_name}";
            set +f
            writeJSONResponseErr "result=>4078" "message=>Error loading file from URL";
            die -q;
        }
    fi
}

function _deploy(){
     [ -f "${WEBROOT}/${context}.war" ] &&  rm -f "${WEBROOT}/${context}.war";
     download_dir=$(mktemp -d)
     getPackageName
     echo $package_name | $GREP -qP "ear$" && ext="ear" || ext="war";
     [ "x${context}" == "xROOT" ] && deploy_context="/" || deploy_context=$context;
     [[ -f "${package_name}" && "${context}.${ext}" != "${package_name}" ]] && cp -f "${package_name}" "/tmp/${context}.${ext}";
     _runAsadminCmd  deploy --force=true --contextroot "$deploy_context" "/tmp/${context}.${ext}" >> $ACTIONS_LOG 2>&1;
     local result=$?;
     rm -rf ${download_dir};
     [ -f "/tmp/${context}.${ext}" ] && rm -f "/tmp/${context}.${ext}"
     return $result;
}

function _undeploy(){
     _runAsadminCmd  undeploy "$context"  >> $ACTIONS_LOG 2>&1;
}
