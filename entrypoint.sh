#!/bin/sh

# check if required paramethers provided
if [ -z "$INPUT_MIGRATIONS_PATH" ]; then
  echo "Input migrations_path is required!"
  exit 1
fi

if [ "$INPUT_DBMS" = 'postgres' ]; then
  FLYWAY_DRIVER='org.postgresql.Driver'
  FLYWAY_URL_PREFIX='jdbc:postgresql'
else
  echo "Invalid dbms. Available: [ postgres ]"
  exit 1
fi

if [ -z "$INPUT_DB_NAME" ]; then
  echo "Input db_name is required!"
  exit 1
fi

if [ -z "$INPUT_DB_PORT" ]; then
  echo "Input db_port is required!"
  exit 1
fi

if [ -z "$INPUT_DB_USER" ]; then
  echo "Input db_user is required!"
  exit 1
fi

if [ -z "$INPUT_DB_PASSWORD" ]; then
  echo "Input db_password is required!"
  exit 1
fi

if [ -z "$INPUT_SSH_KEY" ]; then
  echo "Input ssh_key is required!"
  exit 1
fi

if [ -z "$INPUT_SSH_USER" ]; then
  echo "Input ssh_user is required!"
  exit 1
fi

if [ -z "$INPUT_SSH_HOST" ]; then
  echo "Input ssh_host is required!"
  exit 1
fi

whoami
mkdir -p ~/.ssh
printf '%s\n' "$INPUT_SSH_KEY" > ~/.ssh/private_key
chmod 600 ~/.ssh/private_key
eval $(ssh-agent)
ssh-add ~/.ssh/private_key

touch ~/.ssh/known_hosts
ssh-keygen -R "$INPUT_SSH_HOST"
ssh-keyscan -H "$INPUT_SSH_HOST" >> ~/.ssh/known_hosts

ssh -fN -L 3265:localhost:$INPUT_DB_PORT $INPUT_SSH_USER@$INPUT_SSH_HOST -p $INPUT_SSH_PORT

flyway \
  -locations="filesystem:./$INPUT_MIGRATIONS_PATH" \
  -driver="$FLYWAY_DRIVER" \ 
  -url="$FLYWAY_URL_PREFIX://localhost:3265/$INPUT_DB_NAME" \
  -user=$INPUT_DB_USER \
  -password=$INPUT_DB_PASSWORD \
  migrate
