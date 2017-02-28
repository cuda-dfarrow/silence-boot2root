#!/usr/bin/env bash

export SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

if [ "$USER" != "root" ]; then
	echo "This script must be run as 'root'"
	exit -1
fi

# set up the git user
useradd -m -s /bin/bash git
echo "git:git" | chpasswd

# add Art to the sudoers file
echo "agarfunkel:JaMes1990" | chpasswd
echo "agarfunkel ALL=(ALL) NOPASSWD: /bin/cp" >> /etc/sudoers

# setup paul
useradd -m -s /bin/bash psimon
echo "psimon:kathy" | chpasswd

mkdir -p /home/psimon/.ssh
chown psimon:psimon /home/psimon/.ssh
chmod 700 /home/psimon/.ssh
cat <<EOF > /home/psimon/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCl800NQqs8dr7EyTcQARmod6M39zmRQATbyQdNyzXUhRVsLZXoCYet3BYnT2UcIMakNx5BAsKe0XIk+hIra9+Z1AU/y53tkJUFtT6WLVm77nrsybhVFxCysZGclY3A0nSwkhSZhbWzsc1p3Nx4bM5HfwgHeDS6u+UqmBHy1N3hGlt4R+azYZ5JsVOSUZUMLSHrT+DR38/wv2OryntFa20f1XEBGe//S0fF9v3yJYTH20JeNF1IFiJ7aaWDxPkbyPmvH/a7Q8/tFPhhwFkEnm3r1vtjQHZk8HqKaN//+/R2gW1AHgTCklsRQ9dBEZ6GydwWExBrx/eCLQDy3eaJn/Kn psimon
EOF
cat <<EOF > /home/psimon/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEApfNNDUKrPHa+xMk3EAEZqHejN/c5kUAE28kHTcs11IUVbC2V
6AmHrdwWJ09lHCDGpDceQQLCntFyJPoSK2vfmdQFP8ud7ZCVBbU+li1Zu+567Mm4
VRcQsrGRnJWNwNJ0sJIUmYW1s7HNadzceGzOR38IB3g0urvlKpgR8tTd4RpbeEfm
s2GeSbFTklGVDC0h60/g0d/P8L9jq8p7RWttH9VxARnv/0tHxfb98iWEx9tCXjRd
SBYie2mlg8T5G8j5rx/2u0PP7RT4YcBZBJ5t69b7Y0B2ZPB6imjf//v0doFtQB4E
wpJbEUPXQRGehsncFhMQa8f3gi0A8t3miZ/ypwIDAQABAoIBACCAFNALBYQy8UuS
6LC+tmqy+4lDZsfWlN0Ccua+bI1xfu+PwfMOor7fAouyVef7V0vj643p33nBJSyu
uQ498y2qQ1jqJMTY8waKJ3a77P4MR5DGNM6dVMzaT90twPRJg0btZRFoCVzm7obU
FW2USZXhAA6OcS09DTWZULKRE984vIGrt/xoVIa8d1sDqSueFYvKZDn6oFvmSjMD
bMiPau2J2+UQRHg1uZhfqnw6qZUpFJqDsGMmPF1NVUYsv30IZ5s4xS0KDO8weMuM
8WmYf9x4Hk39bMX5kFzKVi40h3SkD19B7D2r65q18dq1/fsvnSaBHFCNObR471pL
HY03iLECgYEA0NFB8fjq03a69C9f7dLGPlyRiewhTxiv1d4C/w7l+Xc4A5VpsUiH
DnHCCe6ljri0Pg6NZl3kfVsjw+uA2hc3j2ioNY5sIdxKRe/7Ep+JEkX1BxQLRv6m
b3iu43HvCKWL+A+AqHDx70ZT3pTBVUCFJC1sf7BA8yiDPfT9536TTF8CgYEAy3J2
ZTff8jHxXU12Xdv46AcitGT1kOO8YR60mdUQUoKaaDJNWEEqB4sIHlwni/Pu/qeb
GVLvYD5gb+VBUMlAmnN1DdRR7RvA8avME74aDlcJ48CkmvABg8rEPTUPQvRfJgUg
sQkKuZFDnIMRyIXh8RcO+8RAtEFbVvFMzUXJfrkCgYEAp5WJCxztuNAsshPjNQZX
O20nED2FbekuFMGcPf5C6raXKakbrb+7RAhf5YC1NZlebf9X07O+0Cv4xB+YxW6k
lF81v+WROouEwCQcp5GJfDTQtOGNO2jbQdLk6HxjjdjuQCKQ6p3aTGFwpc1Ua4rg
T2x1CvT06zC0Q2D+9G5M4JkCgYA6M+PVLzf9NPaFJ80OKwk5cBkonJ14Nv7EliE6
xS6nPD/qQUHJVtMsV0UaUmjp6/5akh6YDxb2ZMH4IREfiIPX6+H3898AQ2leejSn
DUKtCY+Fva4ZuUHlr1OW4yAbmofB+8OPgjO0RO+fzgt/X3X1IBCkTE/qgawc4mmD
bEyp2QKBgQDPyIn2TE/dIYpujg9EOMRp4L3abNrAxV9ee6N75qXSE64E2QoRA4dO
U+/AMZ6ZYGvcv2wk5oUUZxkJanejlMrvZ7mEitjBfL/of4uFUKn5q3/v1jTT2ApB
lM1tki7u62wiMLKQARhKGk4TmBWWmvDrPZxyJhKuIy8rNFd/Qd5uKw==
-----END RSA PRIVATE KEY-----
EOF
chown psimon:psimon /home/psimon/.ssh/id_rsa*
chmod 600 /home/psimon/.ssh/id_rsa

# copy the web app to paul's dir so we can commit it to the git repo
mkdir -p /home/psimon/silence-webapp && cd /home/psimon/silence-webapp
cp -r $SCRIPT_DIR/www .
cp $SCRIPT_DIR/README.md .
cp $SCRIPT_DIR/setup.sql .
chown -R psimon:psimon .

