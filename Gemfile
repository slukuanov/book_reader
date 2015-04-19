source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'haml-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'simple_form', branch: '3.0.0.rc'
gem 'country_select'
gem 'awesome_nested_fields', github: 'manzhikov/awesome_nested_fields'
gem 'remotipart', '~> 1.2'

gem 'less-rails'
gem 'devise', github: 'plataformatec/devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'cancan'
gem 'summernote-rails'
gem 'noty-rails'

# File uploads
gem 'carrierwave', :git => 'git://github.com/jnicklas/carrierwave.git'
gem 'fog', :git => 'https://github.com/fog/fog.git'
gem 'mini_magick'
gem 'paperclip', :git => 'git://github.com/thoughtbot/paperclip.git'
gem 'jcrop-rails-v2'

gem 'friendly_id', "~> 4.0.0.beta8"
gem 'acts_as_commentable'

# gem 'bcrypt', '~> 3.1.7'
# gem 'unicorn'
# gem 'capistrano-rails', group: :development

group :development do
  gem 'quiet_assets'
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'capistrano-unicorn', require: false
end

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :production do
  gem 'unicorn'
end

group :heroku do
  gem 'rails_12factor'
end


