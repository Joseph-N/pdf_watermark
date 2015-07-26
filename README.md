# PdfWatermark

Add watermark to your pdf. two external gem will be used: combine_pdf and prawn. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pdf_watermark'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pdf_watermark

## Usage
'''ruby
require 'pdf_watermark'

PdfWatermark.watermark("Private and Confidential", "content.pdf", "result.pdf", {:margin => 20,:angle=>:diagonal})
'''
## Development


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pdf_watermark. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

