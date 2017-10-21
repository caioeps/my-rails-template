remove_file 'config/database.yml'
template 'config/database.sample.yml.tt'

copy_file 'config/initializers/generators.rb'
copy_file 'config/initializers/locale.rb'
copy_file 'config/initializers/log_rotator.rb'

copy_file 'config/locales/pt-BR.yml'

copy_file 'config/brakeman.yml'

