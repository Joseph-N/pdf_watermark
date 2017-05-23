require 'pdf_watermark/water_mark/base'
module PdfWatermark
  module WaterMark
    class Repeated < PdfWatermark::WaterMark::Base

      def initialize(*args)
        super(*args)
      end

      def render
        document.pages.each do |page|
          canvas = page.canvas(type: :overlay)
          canvas.font(:watermark_font, size: @font_size)
          canvas.fill_color(@options[:font_color])
          box_height = @font_size
          box_width = canvas.width_of(@mark_string)
          temp_y = @y
          indent = false
          offset_x = box_width + @options[:repeat_offset] * @font_size
          offset_y = box_height + @options[:repeat_offset] * @font_size


          canvas.opacity(fill_alpha: @options[:transparent]) do
            canvas.rotate(@angle, origin: [@content_width/2, @content_height/2]) do
              while temp_y > 0 do
                temp_x = indent ? (offset_x / 2.0) : 0
                while temp_x <= @content_width
                  canvas.text(@mark_string, at: [temp_x, temp_y])
                  temp_x += offset_x
                end
                temp_y -= offset_y
                indent = !indent
              end
            end
          end
        end
        document
      end
    end
  end
end

