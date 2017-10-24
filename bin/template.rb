SETUP_FILE = 'bin/setup'.freeze
UPDATE_FILE = 'bin/update'.freeze

insert_into_file SETUP_FILE, before: /require 'pathname'/ do
  <<~RUBY
    require 'rbconfig'
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

    # Prints an yellow message.
    def warn(msg)
      puts "\e[33m\#{msg}\e[0m"
    end

    # Prints a red message.
    def error(msg)
      puts "\e[33m\#{msg}\e[0m"
    end

    # Return which operational system you're using.
    def os
      @os ||= case RbConfig::CONFIG['host_os']
              when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
                warn "You're using Windows. Please, consider moving to an unix enviroment like any Linux distribution or Mac OS."
                :windows
              when /darwin|mac os/
                :macosx
              when /linux/
                :linux
              when /solaris|bsd/
                :unix
              else
                raise Error::WebDriverError, "Unknown os."
              end
    end

    def install_imagemagick_command
      case os
      when :linux then 'sudo apt-get install imagemagick'
      when :macosx, :unix, :windows
        raise NotImplementedError, "Please, add the install command of imagemagick to #{__FILE__}"
      end
    end

    def install_libmagick_command
      case os
      when :linux then 'sudo apt-get install libmagick++-dev'
      when :macosx, :unix, :windows
        raise NotImplementedError, "Please, add the install command of libmagick to #{__FILE__}"
      end
    end

    def install_redis_command
      case os
      when :linux
        <<~BASH
          sudo add-apt-repository ppa:chris-lea/redis-server
          sudo apt-get update
          sudo apt-get install redis-server
        BASH
      when :macosx, :unix, :windows
        raise NotImplementedError, "Please, add the install command of redis to #{__FILE__}"
      end
    end
  RUBY
end

insert_into_file SETUP_FILE, after: /chdir APP_ROOT\n/ do
  <<~RUBY
    puts "\\n== Installing imagemagick =="
    system(install_imagemagick_command) ? puts('...done.') : error('...error.')

    puts "\\n== Installing libmagick =="
    system(install_libmagick_command) ? puts('...done.') : error('...error.')

    puts "\\n== Installing redis =="
    if system('which redis-server')
      warn "\\nYou aleady have Redis installed."
    else
      system(install_redis_command) ? puts('...done.') : error('...error.')
    end
  RUBY
end

insert_into_file SETUP_FILE, after: /(bundle install)((.)*)(\n)/ do
  <<-RUBY

  if !heroku_staging_app_name.empty? && !`git remote -v`.match(/staging/)
    puts "\\n== Setting up staging remote =="
    system("git remote add staging \#{STAGING_REMOTE}") ? puts('...done.') : error('...error.')
  elsif !heroku_staging_app_name.empty? && `git remote -v`.match(/staging/)
    puts "\\n== Changing staging remote =="
    system("git remote set-url staging \#{STAGING_REMOTE}") ? puts('...done.') : error('...error.')
  end

  if !heroku_production_app_name.empty? && !`git remote -v`.match(/production/)
    puts "\\n== Setting up production remote =="
    system("git remote add production \#{PRODUCTION_REMOTE}") ? puts('...done.') : error('...error.')
  elsif !heroku_production_app_name.empty? && `git remote -v`.match(/production/)
    puts "\\n== Changing production remote =="
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
