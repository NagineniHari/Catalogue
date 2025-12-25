sudo dnf update -y openssl\* openssh\* -y
## OR
sudo dnf update -y 'openssl*' 'openssh*'

sudo systemctl restart sshd
sshd -t