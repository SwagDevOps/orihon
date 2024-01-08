# frozen_string_literal: true

require_relative('../boot')

vendorer = lambda do |update: false|
  autoload(:Vendorer, 'vendorer')

  %w[Vendorfile.rb Vendorfile]
    .keep_if { File.exist?(_1) }
    .last&.then { |config| Vendorer.new({ update: update }).parse(File.read(config)) }
end

# @see https://github.com/grosser/vendorer/blob/master/bin/vendorer
Pathname.new(__FILE__).basename('.*').to_s.tap do |name|
  desc 'Install files from Vendorfile'
  task "#{name}:install" do
    vendorer.call(update: false)
  end
end
