#secure-ssh.sh
#author ryanm292002
#$@creates a new ssh user user $parameter
#adds a public key from the local repo or curled from the remote repo
#removes roots ability to ssh in
sudo useradd -m -d /home/$1 -s /bin/bash $1;
sudo mkdir /home/$1/.ssh;
sudo cp SYS265/linux/public-keys/id_rsa.pub /home/$1/.ssh/authorized_keys;
sudo chmod 700 /home/$1/.ssh;
sudo chmod 600 /home/$1/.ssh/authorized_keys;
sudo chown -R $1:$1 /home/$1/.ssh;
