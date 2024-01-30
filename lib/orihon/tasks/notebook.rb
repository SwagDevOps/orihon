# frozen_string_literal: true

require_relative('../tasks')
require_relative('prepare')

namespace = File.basename(__FILE__, '.rb')
app = ::Orihon::TaskApp.new

'Open the notebook'.then do |desc|
  app.task("#{namespace}:open", desc: desc) do
    app.actions.fetch(:notebook_open).call
  end
end

'Export the notebook'.then do |desc|
  app.task("#{namespace}:export", ['prepare'], desc: desc) do
    app.actions.fetch(:notebook_export).call
  end
end
