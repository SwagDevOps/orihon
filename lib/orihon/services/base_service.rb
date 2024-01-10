# frozen_string_literal: true

require_relative '../services'

# @abstract
class Orihon::Services::BaseService < Orihon::Configurable
  class << self
    def call(...)
      self.new.call(...)
    end
  end
end
