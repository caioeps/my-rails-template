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
end

def preexisting_git_repo?
  @preexisting_git_repo ||= File.exist?(".git")
  @preexisting_git_repo == true
end

def assert_minimum_rails_version
  requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
  rails_version = Gem::Version.new(Rails::VERSION::STRING)
  return if requirement.satisfied_by?(rails_version)

  prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
    "You are using #{rails_version}. Continue anyway?"
  exit 1 if no?(prompt)
end

apply_template!
