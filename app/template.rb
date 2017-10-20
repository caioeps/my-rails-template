apply "app/assets/javascripts/application.js.rb"
copy_file "app/assets/stylesheets/application.scss"
remove_file "app/assets/stylesheets/application.css"

run 'rm -rf app/controllers/concerns'

run 'rm -rf app/models/concerns'

run 'mkdir app/decorators'

run 'mkdir app/policies'

run 'mkdir app/queries'

run 'mkdir app/services'

run 'mkdir app/validators'

run 'mkdir app/views/shared'
copy_file 'app/views/shared/_header.html.slim'
copy_file 'app/views/shared/_footer.html.slim'
