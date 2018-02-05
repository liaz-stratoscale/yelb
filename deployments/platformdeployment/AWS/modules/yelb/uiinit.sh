#! /bin/bash -v

APPSERVER=${yelb_appserver}

#cat << EOF >> /etc/resolv.conf
#nameserver 8.8.8.8
#search strato
#EOF

# apt-get update -y
# apt-get install -y apt-transport-https ca-certificates curl software-properties-common git
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# apt-key fingerprint 0EBFCD88
# add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# apt-get update -y
# apt-get install -y docker-ce

# gpasswd -a ubuntu docker

echo "$APPSERVER     yelb-app" >> /etc/hosts

docker run -dt -p 80:80 -v /etc/hosts:/etc/hosts kushmarostratoscale/yelb-ui:0.1