# PdfWatermark

Add watermark to your pdf. two external gem will be used: combine_pdf and prawn. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hexapdf', git: 'https://github.com/shibocuhk/hexapdf'
gem 'pdf_watermark'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pdf_watermark

## Usage
```ruby
require 'pdf_watermark'

PdfWatermark.watermark('师博 · 华兴Alpha  华兴Alpha  华兴Alpha', source, destination,
                           options: { angle: 15, align: :center, font_color: '999999', transparent: 0.2,
                                      margin: [0, 0, 0, 0], mode: :repeat, max_font_size: 1000, font_size: '3%' }, validate: false)
```
## Development


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shibocuhk/pdf_watermark. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

