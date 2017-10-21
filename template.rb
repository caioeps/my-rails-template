RAILS_REQUIREMENT = "~> 5.1.0".freeze

# Add the current directory to the path Thor uses
# # to look up files
def source_paths
  Array(super) +
    [File.expand_path(File.dirname(__FILE__))]
end

def apply_template!
  template 'Gemfile.tt', force: true
  copy_file 'gitignore', '.gitignore', force: true

  apply 'app/template.rb'
  apply 'config/template.rb'
end

def assert_minimum_rails_version
  requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
  rails_version = Gem::Version.new(Rails::VERSION::STRING)
  return if requirement.satisfied_by?(rails_version)

  prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
    "You are using #{rails_version}. Continue anyway?"
  exit 1 if no?(prompt)
end

def postgresql_username
  if yes?('Do you want to use a custom database username for development and test?')
    say('Type your custom username below...')
    username = ask('username: ')
    "username: #{username}"
  end
end

def postgresql_password
  if yes?('Do you wan to use a custom database password for development and test?')
    say('Type your custom password below...')
    password = ask('password: ')
    "password: #{password}"
  end
end

def preexisting_git_repo?
  @preexisting_git_repo ||= File.exist?(".git")
  @preexisting_git_repo == true
end

apply_template!
