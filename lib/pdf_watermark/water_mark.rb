require 'prawn'
module PdfWatermark
  class WaterMark
    include Prawn::View

    def initialize(mark_string, options)
      @options = options
      @content_width = options[:content_width]
      @content_height = options[:content_height]
      @angle = options[:angle] == :diagonal ? rad_to_degree(Math.atan(@content_height.to_f/@content_width.to_f)) : options[:angle]
      @mark_string = mark_string
      @font_size = @options[:font_size]
      @font = @options[:font]
      @x = @options[:x] || 0
      @y = @options[:y] || @content_height

    end

    def render
      case @options[:mode]
      when :fill
        fill_content
      when :repeat
        repeat_content
      else
        repeat_content
      end
      document.render
    end

    def fill_content
      @max_text_width = @content_width

      rad = degree_to_rad(@angle)
      if Math.tan(rad) < @content_height.to_f/@content_width.to_f
        @max_text_width = (@content_width/Math.cos(rad)).abs
      else
        @max_text_width = (@content_height/Math.sin(rad)).abs
      end
      @font_size ||= calculated_font_size(@mark_string, MAX_FONT_SIZE, @max_text_width)

      font(@options[:font]) do
        bounding_box([@x, @y], width: @content_width, height: @content_height) do
          rotate @angle, origin: [@content_width/2, @content_height/2] do
            transparent(@options[:transparent]) do
              formatted_text_box(
                [{ text: @mark_string, color: @options[:font_color] }],
                at: [@x - (@max_text_width - @content_width) / 2, @y],
                width: @max_text_width, height: @content_height,
                align: @options[:align], valign: @options[:valign],
                size: @font_size,
              )
            end
          end
        end
      end
    end

    def repeat_content
      font(@font) do
        transparent(@options[:transparent]) do
          box_height = @font_size
          box_width = text_width(@mark_string, @font_size)
          temp_y = @y
          indent = false
          bounding_box([@x, @y], width: @content_width, height: @content_height) do
            while temp_y > 0 do
              rotate @angle, origin: [@content_width/2, @content_height/2] do
                temp_x = indent ? ((box_width + REPEAT_X_OFFSET) / 2) : 0
                while temp_x <= @content_width
                  formatted_text_box(
                    [{ text: @mark_string, color: @options[:font_color] }],
                    at: [temp_x, temp_y],
                    width: box_width, height: box_height,
                    align: @options[:align], valign: @options[:valign],
                    size: @font_size,
                  )
                  temp_x += box_width + REPEAT_X_OFFSET
                end
              end
              temp_y -= box_height + REPEAT_Y_OFFSET
              indent = !indent
            end
          end
        end
      end
    end


    protected
    def text_width(text, size)
      document.width_of text, size: size, margin: 0, left_margin: 0, right_margin: 0
    end

    def calculated_font_size(text, size, max)
      text_width = self.text_width(text, size)
      if text_width > max
        (max / text.size).floor
      else
        size
      end
    end

    def document
      @document ||= Prawn::Document.new(page_size: @options[:source_size], margin: @options[:margin], font: @font)
    end

    def degree_to_rad(angle)
      angle * Math::PI / 180
    end

    def rad_to_degree(rad)
      rad * 180 / Math::PI
    end
  end
end
