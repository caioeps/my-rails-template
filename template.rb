RAILS_REQUIREMENT = "~> 5.1.0".freeze

# Add the current directory to the path Thor uses
# # to look up files
def source_paths
  Array(super) +
    [File.expand_path(File.dirname(__FILE__))]
end

def apply_template!
  copy_file 'gitignore', '.gitignore', force: true

  copy_file 'Gemfile.sample', 'Gemfile', force: true

  apply 'app/template.rb'
  apply 'config/template.rb'
  apply 'bin/template.rb'

  run 'mkdir spec'

  apply 'spec/template.rb'

  after_bundle do
    run 'spring stop'
    git :init
    git add: '.'
    git commit: "-a -m 'Initial commit'"
  end
end

def ask_with_default(question, color, default)
  return default unless $stdin.tty?
  question = (question.split("?") << " [#{default}]?").join
  answer = ask(question, color)
  answer.to_s.strip.empty? ? default : answer
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
    username = ask('username: ', :blue)
    "username: #{username}"
  end
end

def postgresql_password
  if yes?('Do you wan to use a custom database password for development and test?')
    say('Type your custom password below...')
    password = ask('password: ', :blue)
    "password: #{password}"
  end
end

def preexisting_git_repo?
  @preexisting_git_repo ||= File.exist?(".git")
  @preexisting_git_repo == true
end

def production_hostname
  @production_hostname ||=
    ask_with_default("Production hostname?", :blue, "example.com")
end

def staging_hostname
  @staging_hostname ||=
    ask_with_default("Staging hostname?", :blue, "staging.example.com")
end

def template_path
  File.expand_path(File.dirname(__FILE__)) + '/'
end

def use_yarn?
  @use_yarn ||=
    yes?('Do you want to use Yarn to manage your assets dependencies?', :blue)
end

apply_template!
