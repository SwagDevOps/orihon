# frozen_string_literal: true

require_relative '../actions'

class Orihon::Actions::NotebookPrepareStyle < Orihon::Actions::BaseTemplateAction
  autoload(:SassC, 'sassc')

  def call
    return false unless scss?

    {
      style: scss_render_style.to_sym
    }.then do |options|
      (scss_source_map_embed? ? {
        filename: "sassc-#{SassC::VERSION}.stdin",
        source_map_file: ".",
        source_map_embed: true,
        source_map_contents: true,
      } : {}).then { _1.merge(options) }
    end.tap do |options|
      scss_dir.join("#{template_name}.scss")
              .then { |file| SassC::Engine.new(file.read, options).render }
              .then { |css| template_dir.join(scss_output).write(css) }
    end
  end

  protected

  # @return [Boolean]
  def scss?
    config.fetch(:scss_process, false).then do |v|
      return v if v.is_a?(TrueClass) or v.is_a?(FalseClass)

      false
    end
  end

  # @return [Boolean]
  def scss_source_map_embed?
    !!config.fetch(:scss_source_map_embed, false)
  end

  # @return [Symbol]
  def scss_render_style
    config.fetch(:scss_render_style, :expanded).to_sym
  end

  # Path where scss result is written.
  #
  # @return [String]
  def scss_output
    # noinspection RubyMismatchedReturnType
    config.fetch(:scss_output)
  end

  # @return [Pathname]
  def scss_dir
    config.path(:scss_dir)
  end
end
