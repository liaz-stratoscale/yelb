#! /bin/bash -v

cat << EOF >> /etc/resolv.conf
nameserver 8.8.8.8
search strato
EOF

# apt-get update -y
# apt-get install -y apt-transport-https ca-certificates curl software-properties-common git postgresql-client-common postgresql-client-9.6
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# apt-key fingerprint 0EBFCD88
# add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# apt-get update -y
# apt-get install -y docker-ce

# gpasswd -a ubuntu docker
########################################

DBHOST=${db_endpoint}
DBIP=$(dig +short ${db_endpoint})
DBPORT=5432
DBNAME="yelbdatabase"
DBUSER="yelbdbuser"
DBPASS="yelbdbuser"

if [ -z "$DBIP" ]
then
    DBIP=$(echo $DBHOST)
fi

echo "$DBIP:$DBPORT:$DBNAME:$DBUSER:$DBPASS" > ~/.pgpass
chmod 600 ~/.pgpass
echo "$DBIP    yelb-db" >> /etc/hosts

#psql -v ON_ERROR_STOP=1 --username="$DBUSER" -w -d "$DBNAME" -h "$DBIP" <<-EOSQL
#	CREATE TABLE clouds (
#    	name        char(30),
#    	count       integer,
#    	PRIMARY KEY (name)
#	);
#	INSERT INTO clouds (name, count) VALUES ('GCP', 0);
#	INSERT INTO clouds (name, count) VALUES ('AWS', 0);
#	INSERT INTO clouds (name, count) VALUES ('Azure', 0);
#	INSERT INTO clouds (name, count) VALUES ('Symphony', 0);
#EOSQL

psql -v ON_ERROR_STOP=1 --username="$DBUSER" -w -d "$DBNAME" -h "$DBIP" <<-EOSQL
	CREATE TABLE restaurants (
    	name        char(30),
    	count       integer,
    	PRIMARY KEY (name)
	);
	INSERT INTO restaurants (name, count) VALUES ('outback', 0);
	INSERT INTO restaurants (name, count) VALUES ('ihop', 0);
	INSERT INTO restaurants (name, count) VALUES ('bucadibeppo', 0);
	INSERT INTO restaurants (name, count) VALUES ('chipotle', 0);
EOSQL

#####

docker run -dt -v /etc/hosts:/etc/hosts -p 3000:3000 -p 4567:4567 kushmarostratoscale/yelb-app:0.1