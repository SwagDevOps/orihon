# frozen_string_literal: true

require_relative '../actions'

class Orihon::Actions::NotebookPrepareTemplate < Orihon::Actions::BaseTemplateAction
  autoload(:CGI, 'cgi')
  autoload(:HtmlBeautifier, 'htmlbeautifier')

  def call
    fs.mkdir_p(template_dir) unless template_dir.exist?
    fs.cp_r(template_dirs.fetch(0).dirname.glob('*'), template_dir, remove_destination: true)
    # replaces some contents ------------------------------------------------
    template.tap do |file|
      file.read.then do |html|
        replace_builder.call.each { html = html.gsub(_1, _2) }.then { html }
      end.then { beautify? ? HtmlBeautifier.beautify(_1) : _1 }.then { file.write(_1) }
    end
  end

  protected

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

  # @return [Proc]
  def replace_builder
    lambda do
      config.to_h.except(:template_replacements, :info).map do |k, v|
        [%r[{{\s+config\.#{k}\s+}}], CGI.escapeHTML(v.to_s)]
      end.to_h.then do |rep|
        config.fetch(:info).map do |k, v|
          [%r[{{\s+info\.#{k}\s+}}], CGI.escapeHTML(v.to_s)]
        end.to_h.merge(rep)
      end.then do |rep|
        config.fetch(:template_replacements).to_h.transform_keys { %r[#{_1}] }.merge(rep)
      end
    end
  end
end
