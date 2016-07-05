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

function _deploy(){
     [ "x${context}" == "xROOT" ] && deploy_context="/" || deploy_context=$context;
     [ -f "${WEBROOT}/${context}.war" ] &&  rm -f "${WEBROOT}/${context}.war";
     $WGET --no-check-certificate --content-disposition -O "/tmp/${context}.war" "$package_url";
     _runAsadminCmd  deploy --force   --contextroot "$deploy_context" "/tmp/${context}.war" >> $ACTIONS_LOG 2>&1;
     local result=$?;
     [ -f "/tmp/${context}.war" ] && rm "/tmp/${context}.war";
     return $result;
}

function _undeploy(){
     #[ "x${context}" == "xROOT" ] && context="/";
     _runAsadminCmd  undeploy   "$context"  >> $ACTIONS_LOG 2>&1;
}







