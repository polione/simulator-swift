FROM swift:latest

RUN apt-get update && apt-get install -y python3 python3-pip python3-venv python3-mysqldb libmysqlclient-dev