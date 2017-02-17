require "pdf_watermark/version"
require 'pdf_watermark/water_mark'
require 'combine_pdf'
module PdfWatermark

  LIB_DIR = File.dirname(File.realpath(__FILE__))
  BASEDIR = File.join(LIB_DIR, '..')
  FONT_DIR = File.join(LIB_DIR, '..', 'fonts')
  MAX_FONT_SIZE= 75

  def self.watermark(mark_string, source, destination = nil, options: {})
    default={
      angle: :diagonal,
      margin: 50,
      font: "#{FONT_DIR}/wqyzenhei.ttf",
      font_color: "#999999",
      transparent: 0.2,
      align: :center,
      valign: :center,
    }
    options = default.merge(options)

    source_pdf = CombinePDF.load(source)
    source_size = page_size(source_pdf.pages[0])

    options[:width] ||= source_size[0]
    options[:height] ||= source_size[1]

    wm = WaterMark.new(mark_string, options).text_watermark
    water_mark_pdf = CombinePDF.parse(wm).pages[0]

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
