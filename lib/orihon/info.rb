# frozen_string_literal: true

require_relative '../orihon'

class Orihon::Info
  autoload(:IniFile, 'inifile')
  autoload(:Pathname, 'pathname')

  def initialize(file)
    @info = self.read(file)
  end

  # @return [Hash{Symbol => String}]
  def to_h
    self.info.to_h.dup
  end

  def fetch(...)
    self.to_h.fetch(...).dup.freeze
  end

  protected

  # @return [Hash{Symbol => String}]
  attr_reader :info

  # @param file [String, Pathname]
  #
  # @return [Hash{Symbol => String}]
  def read(file)
    Pathname.new(file).realpath.then do |fp|
      IniFile.load(fp).to_h.fetch('Notebook', {})
    end.then do |notebook|
      notebook.transform_keys(&:to_sym)
    end.freeze
  end
end
