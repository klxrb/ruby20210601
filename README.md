# README

## Specs:

* Ruby version
** 3.0.0

* System dependencies
** Rails 6.1.3

* Configuration

* Database creation
** rails db:create

* Database initialization
** rails db:migrate

* Services (job queues, cache servers, search engines, etc.)

## Development

WARNING: this is for local development only

Local Development:
* refer to docker folder


To start local postgresql
* /bin/bash start_pg.sh

## Deployment via Capistrano

* copy `provision.sh` to server, configure, and run
* ```eval `ssh-agent`; ssh-add```
* `cap production deploy:check`
* ssh into the server `ssh deploy@domain.name`
* create the db config in `/home/deploy/app/shared/config/database.yml` (see example below)
* logout of the server
* `cap production setup:copy_linked_master_key`
* `cap production deploy`

### Example `database.yml`

```
production:
  adapter: postgresql
  encoding: unicode
  sslmode: require
  pool: 5
  username: doadmin
  password: xxx
  host: example.com
  port: 25060
  database: defaultdb
```

