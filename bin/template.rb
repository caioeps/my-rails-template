SETUP_FILE = 'bin/setup'.freeze
UPDATE_FILE = 'bin/update'.freeze

insert_into_file SETUP_FILE, before: /require 'pathname'/ do
  <<~RUBY
    require 'thor'
  RUBY
end

insert_into_file SETUP_FILE, after: /include FileUtils\n/ do
  <<~RUBY

    cli = Thor.new

    heroku_staging_app_name =
      cli.ask('What is your staging heroku appname?', :magenta)
    heroku_production_app_name =
      cli.ask('What is your production heroku appname?', :magenta)
  RUBY
end

# The line after setting APP_ROOT
insert_into_file SETUP_FILE, after: /(APP_ROOT =)((.)*)(\n)/ do
  <<~RUBY
    PRODUCTION_REMOTE = "https://git.heroku.com/\#{heroku_production_app_name}.git"
    STAGING_REMOTE    = "https://git.heroku.com/\#{heroku_staging_app_name}.git"
  RUBY
end

insert_into_file SETUP_FILE, after: /(bundle install)((.)*)(\n)/ do
  <<~RUBY
      if !heroku_staging_app_name.empty? && !`git remote -v`.match(/staging/)
        puts "\n== Setting up staging remote =="
        system("git remote add staging \#{STAGING_REMOTE}") ? puts('...done.') : error('...error.')
      elsif !heroku_staging_app_name.empty? && `git remote -v`.match(/staging/)
        puts "\n== Changing staging remote =="
        system("git remote set-url staging \#{STAGING_REMOTE}") ? puts('...done.') : error('...error.')
      end

      if !heroku_production_app_name.empty? && !`git remote -v`.match(/production/)
        puts "\n== Setting up production remote =="
        system("git remote add production \#{PRODUCTION_REMOTE}") ? puts('...done.') : error('...error.')
      elsif !heroku_production_app_name.empty? && `git remote -v`.match(/production/)
        puts "\n== Changing production remote =="
        system("git remote set-url production \#{PRODUCTION_REMOTE}") ? puts('...done.') : error('...error.')
      end
  RUBY
end

# Remove file contents
gsub_file UPDATE_FILE, /(\s|\S)*/, ''
prepend_to_file UPDATE_FILE do
  <<~RUBY
    #!/usr/bin/env ruby

    # bin/setup is idempotent, so we can just reuse it here
    load File.expand_path("../setup", __FILE__)
  RUBY
end
