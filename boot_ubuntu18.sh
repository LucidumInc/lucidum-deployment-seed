#!/bin/bash


set -o errexit


export CUSTOMER_NAME=
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=us-west-1
LUCIDUM_S3_BUCKET=lucidum-repository


echo prepare root venv and awscli for ubuntu18
apt update -y
apt install python3-venv -y
python3 -m venv /root/lucidum_venv
source /root/lucidum_venv/bin/activate
pip3 install --no-cache-dir awscli
aws sts get-caller-identity


echo import gpg private key
rm -fv gpg_private.key
aws ssm get-parameter --name /${CUSTOMER_NAME}/gpg.key \
                      --query Parameter.Value \
                      --output text \
                      --with-decryption > gpg_private.key
gpg --import gpg_private.key
rm -fv gpg_private.key


echo download install_lucidum.sh.asc cyphertext
rm -fv /root/install_lucidum.sh.asc
aws s3 cp s3://${LUCIDUM_S3_BUCKET}/${CUSTOMER_NAME}/boot_init.sh.asc \
  /root/install_lucidum.sh.asc


echo decrypt install_lucidum.sh.asc cyphertext
rm -fr /root/lucidum_venv
rm -fv /root/install_lucidum.sh
gpg --decrypt /root/install_lucidum.sh.asc > /root/install_lucidum.sh
rm -fv /root/install_lucidum.sh.asc


echo run install_lucidum.sh
bash -ex /root/install_lucidum.sh
rm -fv /root/install_lucidum.sh


echo initialization complete
