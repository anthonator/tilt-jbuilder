# tilt-jbuilder [![endorse](http://api.coderwall.com/anthonator/endorsecount.png)](http://coderwall.com/anthonator)

Adds support for rendering Jbuilder templates using Tilt.

[![Build Status](https://secure.travis-ci.org/anthonator/tilt-jbuilder.png)](http://travis-ci.org/anthonator/tilt-jbuilder) [![Coverage Status](https://coveralls.io/repos/anthonator/tilt-jbuilder/badge.png?branch=master)](https://coveralls.io/r/anthonator/tilt-jbuilder?branch=master)

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
teplate.render

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