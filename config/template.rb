template 'config/environments/staging.rb.tt'

remove_file 'config/database.yml'
template 'config/database.sample.yml.tt'

run 'cp config/database.sample.yml config/database.yml'

copy_file 'config/initializers/generators.rb'
copy_file 'config/initializers/locale.rb'
copy_file 'config/initializers/log_rotator.rb'

copy_file 'config/locales/pt-BR.yml'

run 'mkdir config/locales/pt-BR'

copy_file 'config/brakeman.yml'

initializer 'routes_subfolders.rb' do
  <<~RUBY
    app = Rails.application
    routes = Dir[Rails.root.join("config/routes/**/*.rb").to_s]
    app.routes_reloader.paths.unshift(*routes)
    app.config.paths["config/routes.rb"].concat(routes)
  RUBY
end

run 'mkdir config/routes'

# config/application.rb
insert_into_file 'config/application.rb',
  after: /class Application < Rails::Application\n/ do
  <<-RUBY
    config.time_zone = 'Brasilia'
    config.assets.quiet = true
    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths += %W( \#{config.root}/lib )
  RUBY
end

# environments/development.rb
mailer_regex = /config\.action_mailer\.raise_delivery_errors = false\n/
comment_lines "config/environments/development.rb", mailer_regex
insert_into_file "config/environments/development.rb", after: mailer_regex do
  <<-RUBY
  # Ensure mailer works in development.
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => "localhost:3000" }
  config.action_mailer.asset_host = "http://localhost:3000"
  RUBY
end

# environments/test.rb
insert_into_file \
  "config/environments/test.rb",
  after: /config\.action_mailer\.delivery_method = :test\n/ do

  <<-RUBY
  # Ensure mailer works in test
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => "localhost:3000" }
  config.action_mailer.asset_host = "http://localhost:3000"
  RUBY
end

# environments/production.rb
uncomment_lines "config/environments/production.rb",
                /config\.action_dispatch\.x_sendfile_header = 'X-Accel-Redirect' # for NGINX/i
uncomment_lines "config/environments/production.rb", /config\.force_ssl = true/

insert_into_file "config/environments/production.rb",
                 after: /# config\.action_mailer\.raise_deliv.*\n/ do
  <<-RUBY
  # Production email config
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {
    host: "#{production_hostname}",
    protocol: "https"
  }
  config.action_mailer.smtp_settings = {
    address: 'smtp-relay.sendinblue.com',
    port: 587,
    domain: ENV.fetch('SMPT_DOMAIN'),
    user_name: ENV.fetch('SMPT_USERNAME'),
    password: ENV.fetch('SMPT_PASSWORD'),
    authentication: :plain,
    enable_starttls_auto: true
  }
  config.action_mailer.asset_host = "https://#{production_hostname}"
  RUBY
end
