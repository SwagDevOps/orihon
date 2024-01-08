# frozen_string_literal: true

require_relative '../actions'

# @abstract
class Orihon::Actions::BaseTemplateAction < Orihon::Actions::BaseAction
  protected

  # @return [Pathname]
  def tmp_dir
    config.path(:tmp_dir)
  end

  # @return [String]
  def template_name
    config.path(:zim_template).dirname.basename.to_s
  end

  # @return [String]
  def template_filename
    config.path(:zim_template).basename.to_s
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
      config.path(:zim_template),
      template.dirname
    ]
  end

  # Get path to the compiled template.
  #
  # @return [Pathname]
  def template
    tmp_dir.join('zim/template').join(template_name).join(template_filename)
  end
end
