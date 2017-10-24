apply "app/assets/javascripts/application.js.rb"
copy_file "app/assets/stylesheets/application.scss"
remove_file "app/assets/stylesheets/application.css"

run 'rm -rf app/controllers/concerns'
run 'rm -rf app/models/concerns'

run 'mkdir app/adapters'
copy_file 'app/decorators/README.md'

run 'mkdir app/decorators'
copy_file 'app/decorators/README.md'
create_file 'app/decorators/application_decorator.rb' do
  <<~RUBY
    class ApplicationDecorator < SimpleDelegator
      class << self
        def decorate_collection(collection)
          collection.map { |obj| new(obj) }
        end
      end

      private

      def object
        __getobj__
      end

      def helpers
        ApplicationController.helpers
      end
      alias_method :h, :helpers
    end
  RUBY
end

run 'mkdir app/policies'
copy_file 'app/policies/README.md'

run 'mkdir app/queries'
copy_file 'app/queries/README.md'

run 'mkdir app/services'
copy_file 'app/services/README.md'

run 'mkdir app/validators'

run 'mkdir app/views/shared'
copy_file 'app/views/shared/_header.html.slim'
copy_file 'app/views/shared/_footer.html.slim'
