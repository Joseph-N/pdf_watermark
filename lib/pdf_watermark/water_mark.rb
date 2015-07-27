require 'prawn'
module PdfWatermark
  class WaterMark
    include Prawn::View

    def initialize(mark_string, angle, width, height, options={})
      default = {
          font:"",
          x: 0,
          y: -1,
          align: :center,
          valign: :center,
          margin: 5,
          font_size: -1,
          font_color:"9999999",
          transparent: 0.2
      }
      @options = default.merge(options)


      @page_width = width
      @page_height = height

      @angle = (angle == :diagonal) ? rad_to_degree(Math.atan(@page_height.to_f/@page_width.to_f)): angle
      @mark_string = mark_string


      @content_width = @page_width - 2 * @options[:margin]
      @content_height = @page_height - 2 * @options[:margin]
      rad = degree_to_rad(@angle)
      @max_text_width = Math.tan(rad) < @content_height.to_f/@content_width.to_f ?
          (@content_width/Math.cos(rad)).abs :
          (@content_height/Math.sin(rad)).abs
      @x = @options[:x]
      @y = @options[:y] <0 ? @content_height : @options[:y]

    end

    def text_watermark

      font(@options[:font]) do
        @font_size = @options[:font_size] <= 0 ? actual_font_size(MAX_FONT_SIZE) : @options[:font_size]
        bounding_box([@x, @y], :width => @content_width, :height => @content_height) do
          transparent(@options[:transparent]) do
            formatted_text_box(
                [{:text => @mark_string, :color => @options[:font_color]}],
                :at => [@x - (@max_text_width - @content_width) / 2, @y],
                :width => @max_text_width, :height => @content_height,
                :align => @options[:align], :valign =>@options[:valign],
                :size => @font_size,
                :rotate => @angle,
                :rotate_around => :center,
            )

          end
        end
      end
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