require 'spec_helper'
describe PdfWatermark do
  let(:pdf) { create_pdf }

  it 'create watermark' do
    source = File.join(test_root, 'data', 'test.pdf')
    dest = File.join(test_root, 'data', 'result.pdf')
    PdfWatermark.watermark('Private And Confidential ** For 黄依群 of 基石资本 Only ** Do Not Distribute',
                           source, dest, options: { :angle => :diagonal, :font_color => "999999", :transparent => 0.5 })

  end
end
