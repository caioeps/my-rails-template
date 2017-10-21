remove_file 'config/environments/test.rb'
remove_file 'config/environments/development.rb'
remove_file 'config/environments/production.rb'

copy_file 'config/environments/test.rb'
template 'config/environments/development.rb.tt'
template 'config/environments/production.rb.tt'
template 'config/environments/staging.rb.tt'

remove_file 'config/database.yml'
template 'config/database.sample.yml.tt'

copy_file 'config/initializers/generators.rb'
copy_file 'config/initializers/locale.rb'
copy_file 'config/initializers/log_rotator.rb'

copy_file 'config/locales/pt-BR.yml'

copy_file 'config/brakeman.yml'

