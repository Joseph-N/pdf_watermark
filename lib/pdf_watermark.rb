require "pdf_watermark/version"
require 'pdf_watermark/water_mark/repeated'
require 'pdf_watermark/water_mark/single'
module PdfWatermark

  LIB_DIR = File.dirname(File.realpath(__FILE__))
  BASEDIR = File.realpath File.join(LIB_DIR, '..')
  FONT_DIR = File.realpath File.join(LIB_DIR, '..', 'fonts')
  REPEAT_X_OFFSET = 80
  REPEAT_Y_OFFSET = 80

  def self.watermark(mark_string, source, destination = nil, options: {})
    default={
      angle: :diagonal,
      margin: [10, 10, 10, 10],
      font: "#{FONT_DIR}/SourceHanSansSC-Regular.ttf",
      font_size: '12px',
      font_color: "999999",
      transparent: 0.2,
      align: :left,
      valign: :center,
      mode: :fill,
      max_font_size: 50,
      min_font_size: 15,
      repeat_offset: 4
    }
    options = default.merge(options)

    if options[:mode].to_sym == :repeat
      document = PdfWatermark::WaterMark::Repeated.new(mark_string, source, options).render
    else
      document = PdfWatermark::WaterMark::Single.new(mark_string, source, options).render
    end

    document.write(destination)
  end

  def self.page_size(page)
    mediabox = page.mediabox
    [mediabox[2]-mediabox[0], mediabox[3] - mediabox[1]]
  end
end
