require 'bundler'
Bundler.setup

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require_relative '../lib/pdf_watermark'
require 'rspec'

def create_pdf(klass = HexaPDF::Document.new, &block)
  klass.new(margin: 0, &block)
end

def test_root
  File.dirname File.realpath(__FILE__)
end
