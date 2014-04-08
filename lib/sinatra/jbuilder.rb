require "tilt/jbuilder"
require "sinatra/base"

module Sinatra
  module Templates
    def jbuilder(template, options={}, locals={})
      options[:default_content_type] = :json
      render :jbuilder, template, options, locals
    end

    def render_with_view_path_support(engine, data, options = {}, locals = {}, &block)
      # Same as `views` extraction in the original method.
      options[:view_path] = options[:views] || settings.views || "./views" if engine.to_s.downcase == "jbuilder"
      render_without_view_path_support(engine, data, options, locals, &block)
    end
    alias_method :render_without_view_path_support, :render
    alias_method :render, :render_with_view_path_support
  end
end

