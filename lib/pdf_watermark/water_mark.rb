require 'prawn'
module PdfWatermark
  class WaterMark
    include Prawn::View

    def initialize(mark_string, options)
      @options = options
      @page_width = options[:width]
      @page_height = options[:height]
      @angle = options[:angle] == :diagonal ? rad_to_degree(Math.atan(@page_height.to_f/@page_width.to_f)) : options[:angle]
      @mark_string = mark_string


      @content_width = @page_width - 2 * @options[:margin]
      @content_height = @page_height - 2 * @options[:margin]
      rad = degree_to_rad(@angle)
      if Math.tan(rad) < @content_height.to_f/@content_width.to_f
        @max_text_width = (@content_width/Math.cos(rad)).abs
      else
        @max_text_width = (@content_height/Math.sin(rad)).abs
      end

      @x = @options[:x] || 0
      @y = @options[:y] || @content_height

    end

    def text_watermark

      font(@options[:font]) do
        @font_size = @options[:font_size]|| actual_font_size(MAX_FONT_SIZE)
        bounding_box([@x, @y], :width => @content_width, :height => @content_height) do
          transparent(@options[:transparent]) do
            formatted_text_box(
              [{ :text => @mark_string, :color => @options[:font_color] }],
              :at => [@x - (@max_text_width - @content_width) / 2, @y],
              :width => @max_text_width, :height => @content_height,
              :align => @options[:align], :valign => @options[:valign],
              :size => @font_size,
              :rotate => @angle,
              :rotate_around => :center,
            )

          end
        end
      end

      return self.render
    end

    protected
    def text_width(size)

      document.width_of @mark_string, size: size, margin: 0, left_margin: 0, right_margin: 0
    end

    def actual_font_size(size)
      text_width = self.text_width(size)
      if text_width > @max_text_width
        (size * (@max_text_width / text_width)).floor
      else
        size
      end
    end

    def document
      @document ||= Prawn::Document.new(:page_size => [@page_width, @page_height], :margin => @options[:margin])
    end

    def render
      document.render
    end

    def degree_to_rad(angle)
      angle * Math::PI / 180
    end

    def rad_to_degree(rad)
      rad * 180 / Math::PI
    end
  end
end
