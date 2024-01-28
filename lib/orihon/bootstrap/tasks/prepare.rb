# frozen_string_literal: true

require_relative('../boot')
require_relative('dependencies')

actions = Orihon.actions
# @type tasker [Orihon::Services::Tasker]
tasker = Orihon.services.fetch(:tasker)
namespace = File.basename(__FILE__, '.rb')

# hidden tasks to prepare (and build) template --------------------------------

%w[template style].map { "#{namespace}:#{_1}" }.then do |tasks|
  tasker.call(namespace, tasks)
end

tasker.call("#{namespace}:template", ['dependencies:install']) do
  actions.fetch(:notebook_prepare_template).call
end

tasker.call("#{namespace}:style", ['dependencies:install']) do
  actions.fetch(:notebook_prepare_style).call
end
