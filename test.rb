require 'pdf_watermark'
require 'ruby-prof'
RubyProf.start
PdfWatermark.watermark('Private And Confidential ** For 黄依群 of 基石资本 Only ** Do Not Distribute',
                       "test.pdf", "result.pdf", options: { :angle => :diagonal, :font_color => "999999", :transparent => 0.5 })
result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
