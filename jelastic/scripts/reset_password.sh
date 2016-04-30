include os output;

. /etc/jelastic/environment

AS_ADMIN="/opt/repo/versions/${Version}/bin/asadmin";
EMPTY_PASS='userproto;{SSHA256}DdW1VfFCD0AqbQFzsu6Swqel1g1gZZ6f1m87JX6FQYSpu1X/BxTX5A==;asadmin';
PASS_FILE="/opt/repo/.gfpass";

function _setPassword() {

        admin_key_file="/opt/repo/versions/${Version}/glassfish/domains/domain1/config/admin-keyfile";
        echo $J_OPENSHIFT_APP_ADM_PASSWORD > $PASS_FILE;
        echo $EMPTY_PASS | sed 's/userproto/admin/g' > $admin_key_file;
        echo $EMPTY_PASS | sed 's/userproto/jelastic/g' >> $admin_key_file;

        service cartridge restart > /dev/null 2>&1;
        echo -e "AS_ADMIN_PASSWORD=\nAS_ADMIN_NEWPASSWORD=$J_OPENSHIFT_APP_ADM_PASSWORD" >> "/tmp/$$";
        $AS_ADMIN -u admin -W "/tmp/$$" change-admin-password > /dev/null 2>&1;
        $AS_ADMIN -u jelastic -W "/tmp/$$" change-admin-password > /dev/null 2>&1;
        echo -n "AS_ADMIN_PASSWORD=" > "/tmp/$$";
        cat $PASS_FILE >> "/tmp/$$";
        $AS_ADMIN -u admin -W "/tmp/$$" enable-secure-admin > /dev/null 2>&1;
        service cartridge restart > /dev/null 2>&1;        
        rm "/tmp/$$" 2>&1;
}
