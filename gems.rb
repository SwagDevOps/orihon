# frozen_string_literal: true

# ```sh
# bundle config set --local clean 'true'
# bundle config set --local path 'vendor/bundle'
# bundle install
# ```
source 'https://rubygems.org'
git_source(:github) { |name| "https://github.com/#{name}.git" }

group :default do
  gem 'htmlbeautifier', '~> 1.4'
  gem 'inifile'
  gem 'rake', '~> 13.0'
  gem 'sassc', '~> 2.4'
  gem 'vendorer', '~> 0.2'
end
