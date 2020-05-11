sudo apt-get update -y
sudo apt-get install gnupg -y
sudo wget -qO - https://www.mongodb.org/static/pgp/server-${MONGO_VERSION}.asc | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/${MONGO_VERSION} multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list
sudo apt-get update -y
sudo apt-get install -y mongodb-org
sudo cp /tmp/mongod.conf /etc/mongod.conf