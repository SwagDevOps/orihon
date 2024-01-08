# frozen_string_literal: true

class Orihon
  File.realpath(__FILE__).gsub(/\.rb/, '').then do |path|
    $LOAD_PATH.unshift(File.dirname(path))
  end
end
