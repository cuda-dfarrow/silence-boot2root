Silence Build Instructions
===================

Base system
-------------------
1. Create a VM - I chose 1 CPU, 512MB RAM, 8GB HDD
2. Install Debian (or your choice of GNU/Linux)
3. Boot from stable netinst (https://www.debian.org/CD/netinst/)
  1. Keep it simple. Guided partitioning, whole disk.
  2. Set a simple root password (for now) - you'll use it to build the machine
  3. When asked to create a secondary user account, name it "agarfunkel" (Full name: "Art Garfunkel") with a strong password - its password won't be needed by you or by challengers
  4. Choose a mirror near to you
  5. When asked to choose packages, select ONLY "SSH server" and "standard system utilities"

System Setup
-------------------
1. On first boot, log in as root at the VM console
2. In "/etc/ssh/sshd_config" change "PermitRootLogin without-password" to "PermitRootLogin yes"
3. Run

```
service ssh restart
ifconfig | grep inet | grep -v '::' | grep -v '127.'
```

Make note of the IP, hence forth refered to as vm_ip. You can now ssh in as root using your temporary simple password to finish the build. You may want to temporarily add your ssh key to root authorized_keys file (/root/.ssh/authorized_keys).

Set up challenges
-------------------

### From your workstation
```
export vm_ip=[VMIP]
ssh root@$vm_ip 'mkdir -p /tmp/src'
scp -r ./src/* root@$vm_ip:/tmp/src/
ssh root@$vm_ip
```

### From silence
```
# During the install, set MySQL's root password to `6eF9Cqb7Gah1`
chmod -R +X /tmp/src
/tmp/src/makeSilence.sh

# destry any traces of files that have been deleted
dd if=/dev/zero of=/zero
rm /zero

# change the root password and remove any ssh keys
# you might have put in place. Use the following 
# password for root: bDcGPhmyuF41 (or use your own... but
# make sure you write it down)
echo "root:bDcGPhmyuF41" | chpasswd
rm -rf /root/.ssh

poweroff
```

Punch out OVA
-------------------
0. Switch machine to "NAT" networking if it's not already.
1. File --> Export Appliance
2. Select your silence VM and click "Next"
3. Pick a format (OVF 1.0 seems fine) and be sure to name the file `<something>.ova` (so it folds all files in to one)
4. Fill out desired fields
