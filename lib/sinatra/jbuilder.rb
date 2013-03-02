require "tilt/jbuilder"

module Sinatra
  module Templates
    def jbuilder(template, options={}, locals={})
      render :jbuilder, template, options, locals
    end
  end
end

