# frozen_string_literal: true

require_relative('../boot')

# tasks -----------------------------------------------------------------------
Pathname.new(__FILE__).basename('.*').to_s.tap do |name|
  desc 'Open the notebook'
  task "#{name}:open" do
    Orihon::Actions::NotebookOpen.call
  end

  desc 'Export the notebook'
  task "#{name}:export" => [
    Rake::Task.task_defined?('vendorer:install') ? 'vendorer:install' : nil,
    "#{name}:export:prepare"
  ].compact do
    Orihon::Actions::NotebookExport.call
  end

  # hidden tasks to prepare (and build) template in a temporary directory
  %w[template style]
    .map { "#{name}:export:prepare:#{_1}" }
    .then do |tasks|
    task({ "#{name}:export:prepare" => tasks }) {}
  end

  task "#{name}:export:prepare:template" do
    Orihon::Actions::NotebookPrepareTemplate.call
  end

  task "#{name}:export:prepare:style" => [
    "#{name}:export:prepare:template"
  ] do
    Orihon::Actions::NotebookPrepareStyle.call
  end
end
