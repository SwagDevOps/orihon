# frozen_string_literal: true

require_relative '../actions'

# @abstract
class Orihon::Actions::BaseTemplateAction < Orihon::Actions::BaseAction
  protected

  # Config for template used by ``zim`` command.
  #
  # @api private
  TEMPLATE_CONFIG_KEY = :template_file

  # Path joined to ``tmp_dir`` for compiled template (as a basepath).
  #
  # @api private
  TEMPLATE_TMP_PATH = 'zim/template'

  # @return [Pathname]
  def tmp_dir
    config.path(:tmp_dir)
  end

  # @return [String]
  def template_name
    config.path(TEMPLATE_CONFIG_KEY).dirname.basename.to_s
  end

  # @return [String]
  def template_filename
    config.path(TEMPLATE_CONFIG_KEY).basename.to_s
  end

  def template_dir
    template.dirname
  end

  # Get paths for templates>
  #
  # First is original template, second is altered template.
  #
  # @return [Array<Pathname>]
  def template_dirs
    [
      config.path(TEMPLATE_CONFIG_KEY),
      template.dirname
    ]
  end

  # Get path to the compiled template.
  #
  # @return [Pathname]
  def template
    tmp_dir.join(TEMPLATE_TMP_PATH).join(template_name).join(template_filename)
  end
end
