# frozen_string_literal: true

# ```sh
# bundle config set --local clean 'true'
# bundle config set --local path 'vendor/bundle'
# bundle install --standalone
# ```
source 'https://rubygems.org'

def github(repo, options = {}, &block)
  block ||= -> { gem(*[File.basename(repo)].concat([{ github: repo }.merge(options)])) }

  # noinspection RubySuperCallWithoutSuperclassInspection
  super(repo, options, &block)
end

group :default do
  gem 'htmlbeautifier', '~> 1.4'
  gem 'inifile', '~> 3.0'
  gem 'liquid', '~> 5.4'
  gem 'rake', '~> 13.0'
  gem 'sassc', '~> 2.4'
  gem 'vendorer', '~> 0.2'
  gem 'wlang', '~> 3.0'
end

group :development do
  github 'SwagDevOps/kamaze-project', { branch: 'develop' }
  gem 'rubocop', '~> 1.3'
  gem 'sys-proc', '~> 1.1'
  # repl ---------------------------------
  gem 'interesting_methods', '~> 0.1'
  gem 'pry', '~> 0.12'
  gem 'rb-readline', '~> 0.5'
end
