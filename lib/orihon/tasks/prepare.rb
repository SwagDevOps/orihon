# frozen_string_literal: true

require_relative('../tasks')
require_relative('dependencies')

namespace = File.basename(__FILE__, '.rb')
app = ::Orihon::TaskApp.new

# hidden tasks to prepare (and build) template --------------------------------

%w[template style].map { "#{namespace}:#{_1}" }.then do |tasks|
  app.task(namespace, tasks)
end

app.task("#{namespace}:template", ['dependencies:install']) do
  app.actions.fetch(:notebook_prepare_template).call
end

app.task("#{namespace}:style", ['dependencies:install']) do
  app.actions.fetch(:notebook_prepare_style).call
end
