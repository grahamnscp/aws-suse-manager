#!/bin/bash

# create tf/userdata from templates/userdata.template

# load parameter values
source ./params.sh

# sed -i has extra param in OSX
SEDBAK=""

UNAME_OUT="$(uname -s)"
case "${UNAME_OUT}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac
                SEDBAK=".bak"
                ;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${UNAME_OUT}"
esac



# copy and parse template files
USERDATA_DEST=tf/userdata-smgr.sh
cp templates/userdata-smgr.sh.template $USERDATA_DEST

# Subsitute parameter values
sed -i $SEDBAK "s/##SCC_SUSE_MICRO_SUB##/$SCC_SUSE_MICRO_SUB/" $USERDATA_DEST
sed -i $SEDBAK "s/##SCC_SUSE_MANAGER_SUB##/$SCC_SUSE_MANAGER_SUB/" $USERDATA_DEST

sed -i $SEDBAK "s/##SCC_ORG_NAME##/$SCC_ORG_NAME/" $USERDATA_DEST
sed -i $SEDBAK "s/##SCC_ORG_EMAIL_ADDRESS##/$SCC_ORG_EMAIL_ADDRESS/" $USERDATA_DEST

sed -i $SEDBAK "s/##SCC_ORG_USER##/$SCC_ORG_USER/" $USERDATA_DEST
sed -i $SEDBAK "s/##SCC_ORG_PASSWORD##/$SCC_ORG_PASSWORD/" $USERDATA_DEST

sed -i $SEDBAK "s/##SUSE_MANAGER_5_ADMIN_EMAIL##/$SUSE_MANAGER_5_ADMIN_EMAIL/" $USERDATA_DEST
sed -i $SEDBAK "s/##SUSE_MANAGER_5_ADMIN_PWD##/$SUSE_MANAGER_5_ADMIN_PWD/" $USERDATA_DEST

sed -i $SEDBAK "s/##SUSE_MANAGER_5_DOMAIN##/$SUSE_MANAGER_5_DOMAIN/" $USERDATA_DEST
sed -i $SEDBAK "s/##SUSE_MANAGER_5_HOST_PWD##/$SUSE_MANAGER_5_HOST_PWD/" $USERDATA_DEST

# smgrX
SMGR_COUNT=`grep count_smgr tf/terraform.tfvars | awk '{print $3}' | tr -d '"'`
for i in $(seq 1 $SMGR_COUNT);
do
  cp $USERDATA_DEST tf/userdata-smgr$i.sh
  sed -i $SEDBAK "s/smgrX/smgr$i/" tf/userdata-smgr$i.sh
  rm tf/userdata-smgr$i.sh.bak
done
rm $USERDATA_DEST

USERDATA_CLIENT_DEST=tf/userdata-client.sh
cp templates/userdata-client.sh.template $USERDATA_CLIENT_DEST

# tidy up
rm ${USERDATA_DEST}.bak
#rm ${USERDATA_CLIENT_DEST}.bak
exit 0

