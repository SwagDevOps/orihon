# frozen_string_literal: true

require_relative('../boot')
require_relative('prepare')

actions = Orihon.actions
# @type tasker [Orihon::Services::Tasker]
tasker = Orihon.services.fetch(:tasker)
namespace = File.basename(__FILE__, '.rb')

'Open the notebook'.then do |desc|
  tasker.call("#{namespace}:open", desc: desc) do
    actions.fetch(:notebook_open).call
  end
end

'Export the notebook'.then do |desc|
  tasker.call("#{namespace}:export", ['prepare'], desc: desc) do
    actions.fetch(:notebook_export).call
  end
end
