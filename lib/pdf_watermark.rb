require "pdf_watermark/version"
require 'pdf_watermark/water_mark'
require 'combine_pdf'
module PdfWatermark
  file = __FILE__
  file = File.readlink(file) if File.symlink?(file)
  dir = File.dirname(file)


  BASEDIR = File.expand_path(File.join(dir, '..'))
  FONT_DIR = File.expand_path(File.join(dir, '..', 'fonts'))
  MAX_FONT_SIZE= 75

  def self.watermark(mark_string, source, destination, options={})
    default={
        angle: :diagonal,
        width: -1,
        height: -1,
        margin: 50,
        font: "#{FONT_DIR}/wqyzenhei.ttf",
        font_size: -1,
        font_color: "999999",
        transparent: 0.2
    }
    options = default.merge(options)

    source_pdf = CombinePDF.load source
    source_size = page_size(source_pdf.pages[0])

    @width = options[:width] <=0 ? source_size[0] : options[:width]
    @height = options[:height] <=0 ? source_size[1] : options[:height]
    wm = WaterMark.new(mark_string, options[:angle], @width, @height,
                       {:margin => options[:margin], :font => options[:font], :font_size => options[:font_size],
                        :transparent => options[:transparent], :font_color => options[:font_color]})
    wm.text_watermark

    water_mark_pdf = CombinePDF.parse(wm.render()).pages[0]

    source_pdf.pages.each do |page|
      page << water_mark_pdf
    end
    source_pdf.save destination


  end

  def self.page_size(page)
    mediabox = page.mediabox
    [mediabox[2]-mediabox[0], mediabox[3] - mediabox[1]]
  end
end
