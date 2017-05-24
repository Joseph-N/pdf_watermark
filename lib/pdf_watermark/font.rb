require 'hexapdf/font/true_type/font'
require 'hexapdf/content/canvas'
module PdfWatermark
  module Font
    def width_of(string, font_size)
      scale = font_size / 1000.0
      string.codepoints.inject(9) do |memo, code|
        memo + character_width(code)
      end * scale
    end

    def character_width(code)
      return 0 unless glyph_index[code]
      return 0.0 if code == 10
      self[:hmtx][glyph_index[code]].advance_width * scale_factor
    end

    def glyph_index
      @glyph_index ||= self[:cmap].preferred_table
    end

    def scale_factor
      @scale_factor ||= 1000.0 / self[:head].units_per_em
    end
  end

  module Canvas
    def width_of(string, font_size = nil)
      self.font.wrapped_font.width_of(string, font_size || self.graphics_state.font_size) +
        (string.length * self.graphics_state.character_spacing)
    end
  end

  module FontDescriptor
    def perform_validation
      descent = self[:Descent]
      if descent && descent > 0
        self[:Descent] = - descent
      end
      super
    end
  end
end

HexaPDF::Font::TrueType::Font.include(PdfWatermark::Font)
HexaPDF::Content::Canvas.include(PdfWatermark::Canvas)
HexaPDF::Type::FontDescriptor.prepend(PdfWatermark::FontDescriptor)
