# frozen_string_literal: true

require_relative('../boot')

actions = Orihon.actions
# @type tasker [Orihon::Services::Tasker]
tasker = Orihon.services.fetch(:tasker)
namespace = File.basename(__FILE__, '.rb')

'Install dependencies'.then do |desc|
  tasker.call("#{namespace}:install" , desc: desc) do
    actions.fetch(:dependencies_install).call
  end
end
