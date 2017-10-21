remove_file 'config/database.yml'
template 'config/database.sample.yml.tt'

copy_file 'config/initializers/locale.rb'
copy_file 'config/locales/pt-BR.yml'

