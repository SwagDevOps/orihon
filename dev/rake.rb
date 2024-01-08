# frozen_string_literal: true

require 'kamaze/project'
require 'orihon/version'

Kamaze::Project.instance do |project|
  project.subject = Orihon
  project.name = 'orihon'
  # noinspection RubyLiteralArrayInspection
  project.tasks = [
    'cs:correct',
    'cs:control',
    'gem:gemspec',
    'misc:gitignore',
    'shell',
    'version:edit',
  ]
end.load!

# tasks ---------------------------------------------------------------
"#{__FILE__.gsub(/\.rb$/, '')}/tasks/**/*.rb".then do |pattern|
  Dir.glob(pattern)
end.then do |tasks|
  tasks.sort.each { require(_1) }
end
