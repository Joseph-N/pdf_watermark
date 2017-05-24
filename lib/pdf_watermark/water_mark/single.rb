require 'pdf_watermark/water_mark/base'
module PdfWatermark
  module WaterMark
    class Single < PdfWatermark::WaterMark::Base

      def initialize(*args)
        super(*args)
      end

      def render
        document.pages.each do |page|
          canvas = page.canvas(type: :overlay)
          canvas.fill_color(@options[:font_color])
          canvas.font(:watermark_font, size: 18)
          rad = deg_to_rad(@angle)

          if Math.tan(rad) < @content_height.to_f/@content_width.to_f
            max_text_width = (@content_width/Math.cos(rad)).abs
          else
            max_text_width = (@content_height/Math.sin(rad)).abs
          end
          # if user does not provide the font size, scale to fill the whole page
          if @font_size
            canvas.font_size(@font_size)
          else
            @font_size = calculated_font_size(canvas, @mark_string, @options[:max_font_size], max_text_width)
            canvas.font_size(@font_size)
            @x = (@content_width - canvas.width_of(@mark_string))/2 + @options[:margin][3]
            @y = @content_height / 2 + @options[:margin][2]
          end
          canvas.opacity(fill_alpha: @options[:transparent]) do
            canvas.rotate(@angle, origin: [@content_width/2, @content_height/2]) do
              canvas.text(@mark_string, at: [@x, @y])
            end
          end
        end
        document
      end

      def calculated_font_size(canvas, string, max_font, max_width)
        text_width = canvas.width_of(string, max_font)
        if text_width > max_width
          (max_width - canvas.graphics_state.character_spacing * string.size) / string.size
        else
          max_font
        end
      end
    end
  end
end
