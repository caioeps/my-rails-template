apply "app/assets/javascripts/application.js.rb"
copy_file "app/assets/stylesheets/application.scss"
remove_file "app/assets/stylesheets/application.css"

run 'rm -rf app/controllers/concerns'

run 'rm -rf app/models/concerns'

run 'mkdir app/decorators'
copy_file 'app/decorators/README.md'
generate 'draper:install'

run 'mkdir app/policies'
copy_file 'app/policies/README.md'

run 'mkdir app/queries'
copy_file 'app/queries/README.md'

run 'mkdir app/services'

run 'mkdir app/validators'

run 'mkdir app/views/shared'
copy_file 'app/views/shared/_header.html.slim'
copy_file 'app/views/shared/_footer.html.slim'
