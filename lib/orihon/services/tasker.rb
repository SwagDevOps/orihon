# frozen_string_literal: true

require_relative '../services'

# Define rake tasks (with configured namespace).
class Orihon::Services::Tasker < Orihon::Services::BaseService
  autoload(:Rake, 'rake')

  # @param task_name [String, Symbol]
  def call(task_name, dependencies = [], args: nil, desc: nil, &block)
    block ||= ->(*) {}
    Rake.application.last_description = desc unless desc.nil?

    self.transform([task_name]).fetch(0).then do |name|
      Rake::Task.define_task(name, args => transform(dependencies || []), &(block || ->(*) {}))
    end
  end

  protected

  # @param [Array<Symbol, String>]
  #
  # @return [Array<Symbol>]
  def transform(values, from: nil)
    values.map do |value|
      [
        tasks_namespace,
        value,
      ].compact.map(&:to_s).join(':').to_sym
    end
  end

  # @return [Symbol, nil]
  def tasks_namespace
    @tasks_namespace ||= lambda do
      self.config.fetch(:tasks_namespace, nil).then do |v|
        v.to_s.empty? ? nil : v.to_sym
      end
    end.call
  end
end
