#!/bin/bash

LEGACY_LIB="/usr/lib/jelastic/libs/glassfish-ssl.lib";
sed -i 's/--target gfcluster//g' $LEGACY_LIB;

inherit glassfish-ssl;

. /etc/jelastic/environment

_ASADMIN="/opt/repo/versions/${Version}/bin/asadmin";
GF_KEYSTORE="/opt/glassfish/glassfish/domains/domain1/config/keystore.jks";
GF_KEYSTORE_ORIG="/opt/glassfish/glassfish/domains/domain1/config/keystore.jks.orig";
DAS_MAIN_CONFIG="/opt/glassfish/glassfish/domains/domain1/config/domain.xml";
PASS_FILE="/opt/repo/.gfpass";

function _enableSSL(){
   enableSSL $@
}

function _disableSSL(){
   disableSSL $@
}
