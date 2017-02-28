#!/usr/bin/env bash

# leave psimon's trail
cat <<EOF > /home/psimon/.bash_history
git clone ssh://git@localhost:/home/git/silence-webapp.git
cat silence-webapp/README.md
su - agarfunkel
mysql --user=root -p < setup.sql
rm -rf silence-webapp
exit
EOF
chown psimon:psimon /home/psimon/.bash_history
chmod 600 /home/psimon/.bash_history

# leave agarfunkel's trail
cat <<EOF > /home/agarfunkel/.bash_history
sudo cp /home/psimon/silence-webapp/www/* /var/www/html/
exit
EOF
chown agarfunkel:agarfunkel /home/agarfunkel/.bash_history
chmod 600 /home/agarfunkel/.bash_history

# drop the flags
echo 'flag0{heres_2_u_mrs_r0bins0n}' > /var/www/html/flag0_zHHkyfZJUWnx.txt && chown root:root /var/www/html/flag0_zHHkyfZJUWnx.txt && chmod 664 /var/www/html/flag0_zHHkyfZJUWnx.txt
echo 'flag1{lik3_a_bridg3_^over^_tr0ubl3d_wat3r}' > /home/psimon/flag1.txt && chown psimon:psimon /home/psimon/flag1.txt && chmod 440 /home/psimon/flag1.txt
echo 'flag2{c3lia_ur_br34king_my_<3}' > /home/agarfunkel/flag2.txt && chown agarfunkel:agarfunkel /home/agarfunkel/flag2.txt && chmod 440 /home/agarfunkel/flag2.txt
echo 'flag3{HELO_d4rkn3ss_my_0ld_Fr1end}' > /root/flag3.txt && chown root:root /root/flag3.txt && chmod 440 /root/flag3.txt
