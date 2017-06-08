require 'spec_helper'
describe PdfWatermark do
  let(:pdf) { create_pdf }

  let(:source) { File.join(test_root, 'data', 'fc77903f38124070ae84ba916bc79fe6.pdf') }
  let(:dest_single) { File.join(test_root, 'data', 'result_single.pdf') }
  let(:dest_repeat) { File.join(test_root, 'data', 'result_repeat.pdf') }
  it 'create watermark' do

    PdfWatermark.watermark('师博 · 华兴Alpha  华兴Alpha  华兴Alpha', source, dest_single,
                           options: { angle: :diagonal, align: :center, font_color: '999999', transparent: 0.2,
                                      margin: [0, 0, 0, 0], mode: :single, max_font_size: 1000, font_size: nil}, validate: false)
    PdfWatermark.watermark('师博 · 华兴Alpha  华兴Alpha  华兴Alpha', source, dest_repeat,
                           options: { angle: 15, align: :center, font_color: '999999', transparent: 0.2,
                                      margin: [0, 0, 0, 0], mode: :repeat, max_font_size: 1000, font_size: '3%' }, validate: false)
  end

  it 'return io stream' do
    result = PdfWatermark.watermark('师博 · 华兴Alpha  华兴Alpha  华兴Alpha', source, nil,
                                    options: { angle: 15, align: :center, font_color: '999999', transparent: 0.2,
                                               margin: [0, 0, 0, 0], mode: :repeat, max_font_size: 1000, font_size: '3%'}, validate: false)
    dest_single = File.join(test_root, 'data', 'result_single.pdf')
    File.open(dest_single, 'wb') do |f|
      f.write(result)
    end
  end
end
