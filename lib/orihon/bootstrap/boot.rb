# frozen_string_literal: true

:ORIHON_CONFIG.then do |cname|
  unless ::Object.const_defined?(cname)
    ::Orihon.configure.then { ::Object.const_set(cname, _1) }
  end
end
