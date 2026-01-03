sudo dnf update -y openssl\* openssh\* -y
## OR
sudo dnf update -y 'openssl*' 'openssh*'

sudo systemctl restart sshd
Check the ssh connection using this command ---> sshd -t 


## Docker

 aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin
  ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com
  docker build -t ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion} .
  docker images
  docker push ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion}