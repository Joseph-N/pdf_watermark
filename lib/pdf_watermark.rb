require "pdf_watermark/version"
require 'pdf_watermark/water_mark'
require 'combine_pdf'
module PdfWatermark

  LIB_DIR = File.dirname(File.realpath(__FILE__))
  BASEDIR = File.join(LIB_DIR, '..')
  FONT_DIR = File.join(LIB_DIR, '..', 'fonts')
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

    source_pdf = CombinePDF.load(source, allow_optional_content: true)
    source_size = page_size(source_pdf.pages[0])

    options[:source_size] = source_size
    options[:content_width] ||= source_size[0] - (options[:margin][1] + options[:margin][3])
    options[:content_height] ||= source_size[1] - (options[:margin][0] + options[:margin][2])

    wm = WaterMark.new(mark_string, options).render
    water_mark_pdf = CombinePDF.parse(wm, allow_optional_content: true).pages[0]

    source_pdf.pages.each do |page|
      page << water_mark_pdf
    end
    if destination.nil?
      source_pdf.to_pdf
    else
      source_pdf.save destination
    end
  end

  def self.page_size(page)
    mediabox = page.mediabox
    [mediabox[2]-mediabox[0], mediabox[3] - mediabox[1]]
  end
end
