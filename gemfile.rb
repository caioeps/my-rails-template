add_source 'https://rubygems.org'

gem 'active_model_serializers'
gem 'devise'
gem 'draper', '> 3.x'
gem 'enumerize'
gem 'foreman'
gem 'jquery-rails'
gem 'js-routes'
gem 'kaminari'
gem 'omniauth-facebook'
gem 'one_signal'
gem 'pg', '~> 0.18'
gem 'premailer-rails'
gem 'puma', '~> 3.7'
gem 'rack-mini-profiler'
gem 'rails-settings-cached'
gem 'ransack', git: 'https://github.com/activerecord-hackery/ransack'
gem 'react-rails'
gem 'rollbar'
gem 'rubocop', require: false
gem 'searchkick', '~> 2.3'
gem 'sidekiq'
gem 'sitemap_generator'
gem 'slugify'
gem 'turbolinks', '~> 5'
gem 'webpack-rails'

gem_group :development, :test do
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'bundler-audit', require: false
  gem 'dotenv-rails'
  gem 'ffaker'
  gem 'parallel_tests'
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.5.1'
  gem 'shoulda-matchers', '~> 3.1'
end

gem_group :development do
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

gem_group :test do
  gem 'capybara', '~> 2.13'
  gem 'capybara-slow_finder_errors'
  gem 'codeclimate-test-reporter', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'poltergeist'
  gem 'rails-controller-testing', git: 'https://github.com/rails/rails-controller-testing/'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock', require: false
end
