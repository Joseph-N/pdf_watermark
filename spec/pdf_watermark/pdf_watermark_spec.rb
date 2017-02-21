require 'spec_helper'
describe PdfWatermark do
  let(:pdf) { create_pdf }

  it 'create watermark' do
    source = File.join(test_root, 'data', 'test.pdf')
    dest = File.join(test_root, 'data', 'result.pdf')
    PdfWatermark.watermark('测试  ·  测试', source, dest, options: { angle: 15, align: :center, font_color: '999999', transparent: 0.2, margin: [0, 0, 0, 0], mode: :repeat, font_size: 18 })
  end
end
