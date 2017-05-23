require 'spec_helper'
describe PdfWatermark do
  let(:pdf) { create_pdf }

  it 'create watermark' do
    source = File.join(test_root, 'data', '73592162e56a442ea1e70a09c7137d84.pdf')
    dest_single = File.join(test_root, 'data', 'result_single.pdf')
    dest_repeat = File.join(test_root, 'data', 'result_repeat.pdf')
    PdfWatermark.watermark('师博 · 华兴Alpha  华兴Alpha  华兴Alpha', source, dest_single,
                           options: { angle: :diagonal, align: :center, font_color: '999999', transparent: 0.2,
                                      margin: [0, 0, 0, 0], mode: :single, max_font_size: 1000, font_size: nil })
    PdfWatermark.watermark('师博 · 华兴Alpha  华兴Alpha  华兴Alpha', source, dest_repeat,
                           options: { angle: 15, align: :center, font_color: '999999', transparent: 0.2,
                                      margin: [0, 0, 0, 0], mode: :repeat, max_font_size: 1000, font_size: '3%' })
  end
end
