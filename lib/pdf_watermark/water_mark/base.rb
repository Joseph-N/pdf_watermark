require 'hexapdf'
require 'hexapdf/utils/math_helpers'
require 'pdf_watermark/font'
module PdfWatermark
  module WaterMark
    class Base
      include HexaPDF::Utils::MathHelpers

      def initialize(mark_string, source_path, options)
        @source_path = source_path
        @options = options
        source_size = page_size
        @content_width = source_size[0] - (options[:margin][1] + options[:margin][3])
        @content_height = source_size[1] - (options[:margin][0] + options[:margin][2])
        @angle = options[:angle] == :diagonal ? rad_to_deg(Math.atan(@content_height.to_f/@content_width.to_f)) : options[:angle]
        @mark_string = mark_string

        @font_size = @options[:font_size]
        if @font_size.is_a?(String)
          if @font_size =~ /(\d+[.]?\d*)%/
            @font_size = ($1.to_f / 100) * @content_width
            @font_size = [@font_size, @options[:max_font_size]].min
            @font_size = [@font_size, @options[:min_font_size]].max
          else
            @font_size = @font_size.to_i
          end
        end
        @options[:font]
        @x = @options[:x] || 0
        @y = @options[:y] || @content_height

        @font = load_font(@options[:font], :watermark_font)
      end


      protected

      def load_font(font_path, name = nil)
        font_name = name.nil? ? File.basename(font_path, '.ttf') : name
        map = {}
        map[font_name] = { none: font_path }
        document.config['font.map'].merge!(map)

        document.fonts.load(font_name).wrapped_font
      end

      def page_size
        box = document.pages[0].box.value
        [box[2] - box[0], box[3] - box[1]]
      end

      def document
        @document ||= HexaPDF::Document.open(@source_path)
      end
    end
  end
end
