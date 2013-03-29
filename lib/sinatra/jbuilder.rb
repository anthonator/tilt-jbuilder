require "tilt/jbuilder"
require "sinatra/base"

module Sinatra
  module Templates
    def jbuilder(template, options={}, locals={})
      render :jbuilder, template, options, locals
    end

    def render_with_view_path_support(engine, data, options = {}, locals = {}, &block)
      options[:view_path] = options[:views] if engine.to_s.downcase == "jbuilder"
      render_without_view_path_support(engine, data, options, locals, &block)
    end
    alias_method :render_without_view_path_support, :render
    alias_method :render, :render_with_view_path_support
  end
end

