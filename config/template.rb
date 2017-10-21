remove_file 'config/database.yml'
template 'config/database.sample.yml.tt'

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
