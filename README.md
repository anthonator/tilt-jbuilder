# tilt-jbuilder

Adds support for rendering Jbuilder templates using Tilt.

[![Gem Version](https://badge.fury.io/rb/tilt-jbuilder.png)](http://badge.fury.io/rb/tilt-jbuilder) [![Build Status](https://secure.travis-ci.org/anthonator/tilt-jbuilder.png)](http://travis-ci.org/anthonator/tilt-jbuilder) [![Dependency Status](https://gemnasium.com/anthonator/tilt-jbuilder.png)](https://gemnasium.com/anthonator/tilt-jbuilder) [![Coverage Status](https://coveralls.io/repos/anthonator/tilt-jbuilder/badge.png?branch=master)](https://coveralls.io/r/anthonator/tilt-jbuilder?branch=master) [![Code Climate](https://codeclimate.com/github/anthonator/tilt-jbuilder.png)](https://codeclimate.com/github/anthonator/tilt-jbuilder)

## Installation

Add this line to your application's Gemfile:

    gem 'tilt-jbuilder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tilt-jbuilder

## Usage

```ruby
require 'tilt/jbuilder.rb'

template = Tilt::JbuilderTemplate.new("templates/awesomeness.json.jbuilder")
template.render

# With locals
template = Tilt::JbuilderTemplate.new { "json.author name" }
template.render(nil, :name => 'Anthony')

# With scope
template = Tilt::JbuilderTemplate.new { "json.author @name" }
scope = Object.new
scope.instance_variable_set :@name, 'Anthony'
template.render(scope)

# Block style
template = Tilt::JbuilderTemplate.new do |t|
  lambda { |json| json.author 'Anthony'; json.target! }
end
template.render
```

## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

[![Sticksnleaves](https://s3.amazonaws.com/sticksnleaves-assets/snl-logo-116x116.png)](http://www.sticksnleaves.com)

tilt-jbuilder is maintained and funded by [Sticksnleaves](http://www.sticksnleaves.com)

Thanks to all of our [contributors](https://github.com/anthonator/tilt-jbuilder/graphs/contributors)
