# frozen_string_literal: true

require_relative '../orihon'

class Orihon::Config
  autoload(:Pathname, 'pathname')
  autoload(:YAML, 'yaml')

  def initialize(file)
    Pathname.new(file).realpath.read.then do |content|
      @config = YAML.safe_load(content).then do |v|
        self.class.__send__(:defaults).merge(v)
      end.then do |v|
        Pathname.new(v.fetch('zim_src_dir')).join('notebook.zim').realpath.then do |fp|
          v.merge({ 'info' => ::Orihon::Info.new(fp).to_h })
        end
      end
    end
  end

  # @return [Hash{Symbol => Object}]
  def to_h
    self.config.dup.transform_values(&:dup).transform_keys(&:to_sym)
  end

  def fetch(...)
    self.to_h.fetch(...).dup.freeze
  end

  # @param key [String, Symbol]
  #
  # @return [Pathname]
  def path(key)
    self.to_h.fetch(key.to_sym).then do |value|
      Pathname.pwd.join(value.to_s).freeze
    end
  end

  protected

  # @return [Hash{String => Object}]
  attr_reader :config

  class << self
    protected

    # @return [Hash{String => Object}]
    def defaults
      {
        tasks_debug: false,
        html_lang: ::ENV['LANG']&.split('_')[0],
        zim_src_dir: 'notebook',
        zim_export_dir: 'export',
        tmp_dir: 'tmp',
        # add custom styles ---------------------------------------------------
        scss_process: true,
        scss_dir: 'resources/scss',
        scss_source_map_embed: true,
        scss_render_style: :expanded,
        # replacements --------------------------------------------------------
        template_beautify: true,
      }.transform_keys(&:to_s).compact
    end
  end
end
