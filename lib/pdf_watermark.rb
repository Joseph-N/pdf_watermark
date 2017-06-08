require "pdf_watermark/version"
require 'pdf_watermark/water_mark/repeated'
require 'pdf_watermark/water_mark/single'
module PdfWatermark

  include HexaPDF::Encryption::StandardSecurityHandler::Permissions

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
      repeat_offset: 4,
      validate: true,
    }
    options = default.merge(options)

    if options[:mode].to_sym == :repeat
      document = PdfWatermark::WaterMark::Repeated.new(mark_string, source, options).render
    else
      document = PdfWatermark::WaterMark::Single.new(mark_string, source, options).render
    end

    if options[:read_only]
      permissions = 1
      document.encrypt(name: :Standard, owner_password: options[:password], permissions: permissions)
    end


    if destination
      document.write(destination, validate: options[:validate])
    else
      StringIO.open('', 'wb') do |io|
        document.write(io, validate: options[:validate])
        io.string
      end
    end
  end

  def self.page_size(page)
    mediabox = page.mediabox
    [mediabox[2]-mediabox[0], mediabox[3] - mediabox[1]]
  end
end
