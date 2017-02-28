#! /usr/bin/env bash

if [ "$USER" != "git" ]; then
	echo "This script must be run as 'git'"
	exit -1
fi

# setup ssh key for psimon
mkdir /home/git/.ssh && chmod 0700 /home/git/.ssh
touch /home/git/.ssh/authorized_keys && chmod 600 /home/git/.ssh/authorized_keys
cat <<EOF > /home/git/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCl800NQqs8dr7EyTcQARmod6M39zmRQATbyQdNyzXUhRVsLZXoCYet3BYnT2UcIMakNx5BAsKe0XIk+hIra9+Z1AU/y53tkJUFtT6WLVm77nrsybhVFxCysZGclY3A0nSwkhSZhbWzsc1p3Nx4bM5HfwgHeDS6u+UqmBHy1N3hGlt4R+azYZ5JsVOSUZUMLSHrT+DR38/wv2OryntFa20f1XEBGe//S0fF9v3yJYTH20JeNF1IFiJ7aaWDxPkbyPmvH/a7Q8/tFPhhwFkEnm3r1vtjQHZk8HqKaN//+/R2gW1AHgTCklsRQ9dBEZ6GydwWExBrx/eCLQDy3eaJn/Kn psimon
EOF

# create the project on the "server"
mkdir -p /home/git/silence-webapp.git
cd /home/git/silence-webapp.git && git init --bare

