source "https://rubygems.org"

gem "sinatra", "~> 2.0"
gem "rake", "~> 12.3"
gem "activerecord", "~> 5.1", :require => 'active_record'
gem "require_all", "~> 2.0"
gem "sinatra-activerecord", "~> 2.0", :require => 'sinatra/activerecord'
gem "bcrypt", "~> 3.1"
gem "sqlite3", "~> 1.3"

group :development do
  gem "shotgun", "~> 0.9.2", :group => [:development]
  gem "tux", "~> 0.3.0", :group => [:development]
end

group :test do
  gem "rspec", "~> 3.7"
  gem "capybara", "~> 2.18"
  gem "rack-test", "~> 0.6.3"
  gem "pry", "~> 0.11.3"
end
