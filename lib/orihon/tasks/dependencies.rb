# frozen_string_literal: true

require_relative('../tasks')

namespace = File.basename(__FILE__, '.rb')
app = ::Orihon::TaskApp.new

'Install dependencies'.then do |desc|
  app.task("#{namespace}:install", desc: desc) do
    app.actions.fetch(:dependencies_install).call
  end
end
