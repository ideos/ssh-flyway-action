# SSH Flyway Action

This actions runs flyway commands over ssh

## Inputs

### `migrations_path`

### `dbms`

### `db_name`

### `db_port`

### `db_user`

### `db_password`

### `ssh_host`

Remote host where docker is running

### `ssh_port`

SSH port on remote host

### `ssh_user`

SSH user on remote host

### `ssh_key`

SSH private key used to access to remote server.
Better save it into repository secrets.

### Example usage

```yaml
steps:
  # need checkout before using docker-compose-remote-action
  - uses: actions/checkout@v2
  - uses: chaplyk/docker-compose-remote-action@v1.1
    with:
      migrations_path: conf/migrations
      dbms: postgres
      db_name: ${{ secrets.DB_NAME }}
      db_port: 5432
      db_user: ${{ secrets.DB_USER }}
      db_password: ${{ secrets.DB_PASSWORD }}
      ssh_host: 127.0.0.1
      ssh_user: username
      ssh_key: ${{ secrets.SSH_KEY }}
  
```
