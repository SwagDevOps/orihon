# frozen_string_literal: true

# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# rubocop:disable all
<?rb
@files = [
    '.yardopts',
    'README.md',
    'bin/*',
    'lib/**/*.rb',
    'lib/**/*.erb',
    'lib/**/version.yml',
].map { |m| Dir.glob(m) }.flatten.keep_if { |f| File.file?(f) }.sort

self.singleton_class.__send__(:define_method, :quote) do |input|
  input.to_s.inspect
end
?>

# noinspection RubyLiteralArrayInspection
Gem::Specification.new do |s|
  s.name        = #{quote(@name)}
  s.version     = #{quote(@version)}
  s.date        = #{quote(@date)}
  s.summary     = #{quote(@summary)}

  s.authors     = #{@authors}
  s.email       = #{quote(@email)}
  s.homepage    = #{quote(@homepage)}

  s.required_ruby_version = #{quote(@required_ruby_version)}
  s.require_paths = ["lib"]
  s.files         = [
    <?rb for file in @files ?>
    #{"%s," % quote(file)}
    <?rb end ?>
  ]

  #{@dependencies.keep(:runtime).to_s.lstrip}
end

# Local Variables:
# mode: ruby
# End:
