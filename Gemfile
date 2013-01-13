source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'bootstrap-sass', '2.1.1.0'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.9'

group :development, :test do
  gem 'sqlite3', '1.3.6'
  gem 'rspec-rails', '2.11.4'
  gem 'guard-rspec', '2.1.1'
  gem 'annotate', '2.5.0'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.5'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.3.0'
end

gem 'jquery-rails', '2.1.3'

group :test do
  gem 'rspec-rails', '2.11.4'
  gem 'capybara', '1.1.2'
  gem 'guard-spork', '1.2.3'
  gem 'spork', '0.9.2'
  gem 'factory_girl_rails', '4.1.0'

  # For watching the file system and notifications on...
  #   linux
  gem 'rb-inotify', '0.8.8', require: false
  gem 'libnotify', '0.8.0', require: false
  #   os x
  gem 'rb-fsevent', '0.9.3', require: false
  gem 'growl', '1.0.3', require: false
  #   windows
  gem 'wdm', '0.0.3', :platforms => [:mswin, :mingw], :require => false
  gem 'rb-notifu', '0.0.4', require: false
end

group :production do
  gem 'pg', '0.14.1'
end
