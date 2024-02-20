# frozen_string_literal: true

require_relative '../services'

# Read ``notebook`` file as a ``Hash``.
class Orihon::Services::Info < Orihon::Services::BaseService
  autoload(:IniFile, 'inifile')
  autoload(:Pathname, 'pathname')

  # @return [Hash{Symbol => String}]
  def call
    read(filepath)
  end

  protected

  # @return [Pathname]
  def filepath
    src_dir.join('notebook.zim')
  end

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

  # @return [Pathname]
  def src_dir
    config.fetch(:notebook_dir)
          .to_s
          .then { Pathname.new(_1) }
          .expand_path
  end
end
