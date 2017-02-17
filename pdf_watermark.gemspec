# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pdf_watermark/version'

Gem::Specification.new do |spec|
  spec.name          = "pdf_watermark"
  spec.version       = PdfWatermark::VERSION
  spec.authors       = ["bruce"]
  spec.email         = ["shibocuhk@gmail.com"]

  spec.summary       = %q{pdf watermark}
  spec.description   = %q{add watermark to pdf files}
  spec.homepage      = "http://bruceshi.me"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.test_files = Dir['spec/*_spec.rb']

  spec.add_dependency('prawn', '~> 2.1.0')
  spec.add_dependency('combine_pdf')

  spec.add_development_dependency('bundler', '~> 1.10')
  spec.add_development_dependency('rake', '~> 10.0')
  spec.add_development_dependency('rspec', '~> 3.0')
  spec.add_development_dependency('rubocop', '~> 0.47.1')
  spec.add_development_dependency('rubocop-rspec', '~> 1.10')
  spec.add_development_dependency('simplecov')
end
