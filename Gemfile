source 'http://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

gem 'activeadmin', '0.4.4'
gem 'paperclip'
gem 'paper_trail', '~> 2'
# gem 'haml', '3.1.7'
gem 'haml_assets'
gem "twitter-bootstrap-rails"

gem 'active_model_serializers'


group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
end


# Use unicorn as the web server
# gem 'unicorn'

# Deploy with RVM and Capistrano

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :production do 
  gem 'passenger'
end

group :development do
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem "rails-erd"
end

group :test do 
  gem 'database_cleaner', '>= 0.9.1'
end

group :test, :development do
  gem 'rspec-rails'
  gem "factory_girl_rails", "~> 4.0"
end
