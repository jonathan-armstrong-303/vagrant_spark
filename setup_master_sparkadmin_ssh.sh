u - !/bin/bash

# assign password -- needs to be the same throughout the process of course
  sparkadmin_password="r0xs0xb0x"

# activities to facilitate passwordless ssh.
# make ssh directory and apply right permissions.  Very important!

  cd /home/sparkadmin
  mkdir ~/.ssh
  chmod 700  ~/.ssh
 
# Generate ssh key
/usr/bin/expect<<EOF
  spawn ssh-keygen 
  expect "Enter file in which to save the key (/root/.ssh/id_rsa): "
  send  "\r"
  expect "Enter passphrase (empty for no passphrase): "
  send  "\r"
  expect "Enter same passphrase again: "
  send  "\r"
  expect
EOF

# apply right permissions to recently created keys.
  chmod 600 ~/.ssh/id_rsa
  chmod 644 ~/.ssh/id_rsa.pub

# Apply permissions below.  Superfluous?  Yes. Not all these files are generated, but permissions
# included for posterity/breadcrumbs since the author can never remember them

  touch ~/.ssh/authorized_keys
  touch ~/.ssh/known_hosts
  chmod 644 ~/.ssh/authorized_keys
  chmod 644 ~/.ssh/known_hosts
  
#   chmod 700 ~/.ssh
#   chmod 600 ~/.ssh/id_rsa
#   chmod 644 ~/.ssh/id_rsa.pub
#   chmod 644 ~/.ssh/authorized_keys
#   chmod 644 ~/.ssh/known_hosts
#   restorecon -R ~/.ssh

# copy over id_rsa.pub ssh key to standby / segment servers

# yeah, I know this is an egregious violation of DRY right here, but was having some issues
# wrapping the expect script in a for loop. 
sparkserver="slave01"
  /usr/bin/expect<<EOF
  spawn ssh-copy-id ${sparkserver}
  expect "Are you sure you want to continue connecting (yes/no/[fingerprint])? "
  send "yes\r"
  expect "sparkadmin@${sparkserver}'s password: "
  send  "${sparkadmin_password}\r"
  expect
EOF

sparkserver="slave02"
  /usr/bin/expect<<EOF
  spawn ssh-copy-id ${sparkserver}
  expect "Are you sure you want to continue connecting (yes/no/[fingerprint])? "
  send "yes\r"
  expect "sparkadmin@${sparkserver}'s password: "
  send  "${sparkadmin_password}\r"
  expect
EOF

