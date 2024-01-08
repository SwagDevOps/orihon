# frozen_string_literal: true

require_relative '../actions'

class Orihon::Actions::NotebookOpen < Orihon::Actions::BaseAction
  def call
    detach(['zim', filepath])
  end

  protected

  # @return [Pathname]
  def filepath
    config.path(:zim_src_dir).join('notebook.zim')
  end
end
