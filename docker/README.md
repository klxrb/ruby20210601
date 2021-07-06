To start local postgresql
* /bin/bash start_pg.sh


WARNING: this is for local development only


## Capistrano

* ```eval `ssh-agent`; ssh-add```
* configure `Gemfile` and `Capfile`
* configure `deploy.rb` and `production.rb`
* `cap production deploy:check`
* ssh into the server `ssh deploy@domain.name`
* create the db config in `shared/config/database.yml` (see example below)
* `cap production setup:copy_linked_master_key`
* `cap production deploy`

### Example `database.yml`

```
production:
  adapter: postgresql
  encoding: unicode
  database: RubyWorkshop_production
  username: dev
  password: example
  pool: 5
  port: 5432
  host: localhost
```
