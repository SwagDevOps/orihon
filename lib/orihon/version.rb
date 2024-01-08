# frozen_string_literal: true

require_relative '../orihon'

unless Orihon.constants(false).include?(:VERSION)
  require 'kamaze/version'

  File.realpath(__FILE__).gsub(/\.rb$/, '.yml').then do |version_file|
    ::Kamaze::Version.new(version_file)
  end.then do |version|
    Orihon::VERSION = version.freeze
  end
end
