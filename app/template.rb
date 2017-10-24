apply "app/assets/javascripts/application.js.rb"
copy_file "app/assets/stylesheets/application.scss"
remove_file "app/assets/stylesheets/application.css"

run 'rm -rf app/controllers/concerns'
run 'rm -rf app/models/concerns'

directory 'app/adapters'
directory 'app/decorators'
directory 'app/nulls'
directory 'app/policies'
directory 'app/queries'
directory 'app/services'
directory 'app/validators'

copy_file 'app/views/layouts/application.html.slim'
remove_file 'app/views/layouts/application.html.erb'
remove_file 'app/views/layouts/mailer.text.erb'

directory 'app/views/shared'

