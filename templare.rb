# Add the current directory to the path Thor uses
# # to look up files
def source_paths
  Array(super) +
    [File.expand_path(File.dirname(__FILE__))]
end

###########
# Gemfile #
###########
remove_file 'Gemfile'
copy_file 'Gemfile'

##############
# .gitignore #
##############
remove_file '.gitignore'
copy_file 'gitignore', '.gitignore'
