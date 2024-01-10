# frozen_string_literal: true

require_relative '../actions'

class Orihon::Actions::NotebookPrepareTemplate < Orihon::Actions::BaseTemplateAction
  autoload(:HtmlBeautifier, 'htmlbeautifier')

  def initialize(config: nil, structurizer: nil, templater: nil, info: nil)
    super(config: config)

    ::Orihon.services.tap do |services|
      @structurizer = structurizer || services.fetch(:structurizer)
      @templater = templater || services.fetch(:template)
      @info = info || services.fetch(:info)
    end
  end

  def call
    fs.mkdir_p(template_dir) unless template_dir.exist?
    fs.cp_r(template_dirs.fetch(0).dirname.glob('*'), template_dir, remove_destination: true)

    template.read.then do |html|
      # replaces some contents ------------------------------------------------
      replacements.each do |k, v|
        html = html.gsub(k, v)
      end

      templater.call(html, variables)
    end.then do |html|
      beautify? ? HtmlBeautifier.beautify(html) : html
    end.then do |html|
      template.write(html)
    end
  end

  protected

  # @return [Class<Orihon::Services::Structurizer>, Orihon::Services::Structurizer]
  attr_reader :structurizer

  # @return [Class<Orihon::Services::Template>, Orihon::Services::Template]
  attr_reader :templater

  # @return [Class<Orihon::Services::Info>, Orihon::Services::Info]
  attr_reader :info

  def beautify?
    config.fetch(:template_beautify)
  end

  # @return [Pathname]
  def export_dir
    config.path(:zim_export_dir)
  end

  # @return [Pathname]
  def src_dir
    config.path(:zim_src_dir)
  end

  # @return [Hash{Regexp => String}]
  def replacements
    config.fetch(:template_replacements).to_h.transform_keys { %r[#{_1}] }
  end

  # @return [Hash{Symbol => Struct}]
  def variables
    {
      config: config.to_h,
      info: info.call,
    }.transform_values do |value|
      structurizer.call(value)
    end
  end
end
