require 'tilt'
require 'jbuilder'

module Tilt
  class Jbuilder < ::Jbuilder
    def initialize(scope, *args, &block)
      @scope = scope
      super(*args, &block)
    end

    def partial!(name_or_options, locals = {})
      case name_or_options
      when ::Hash
        # partial! partial: 'name', locals: { foo: 'bar' }
        options = name_or_options
      else
        # partial! 'name', foo: 'bar'
        options = { partial: name_or_options, locals: locals }
        as = locals.delete(:as)
        options[:as] = as if as.present?
        options[:collection] = locals[:collection] if locals.key?(:collection)
      end

      view_path = @scope.instance_variable_get('@_jbuilder_view_path')
      template = ::Tilt::JbuilderTemplate.new(fetch_partial_path(options[:partial].to_s, view_path), nil, view_path: view_path)
      render_partial_with_options template, options
    end

    def array!(collection = [], *attributes, &block)
      options = attributes.extract_options!

      if options.key?(:partial)
        partial! options[:partial], options.merge(collection: collection)
      else
        super
      end
    end

    # for now caching is not supported, but at least we can transparently ignore it
    def cache!(key=nil, options={}, &block)
      yield
    end

    private
    def fetch_partial_path(file, view_path)
      view_path ||= ::Dir.pwd
      ::Dir[::File.join(view_path, partialized(file) + ".{*.,}jbuilder")].first
    end

    def partialized(path)
      partial_file = path.split("/")
      partial_file[-1] = "_#{partial_file[-1]}" unless partial_file[-1].start_with?("_")
      partial_file.join("/")
    end

    def render_partial_with_options(template, options)
      options[:locals] ||= {}
      if options[:as] && options.key?(:collection)
        collection = options.delete(:collection)
        locals = options.delete(:locals)
        array! collection do |member|
          member_locals = locals.clone
          member_locals.merge! options[:as] => member
          render_partial template, member_locals
        end
      else
        render_partial template, options[:locals]
      end
    end

    def render_partial(template, options)
      options.merge! json: self
      template.render @scope, options
    end
  end

  class JbuilderTemplate < Template
    self.default_mime_type = 'application/json'

    def self.engine_initialized?
      defined? ::Jbuilder
    end

    def initialize_engine
      require_template_library 'jbuilder'
    end

    def prepare; end

    def evaluate(scope, locals, &block)
      scope ||= Object.new
      ::Tilt::Jbuilder.encode(scope) do |json|
        context = scope.instance_eval { binding }
        set_locals(locals, scope, context)
        if data.kind_of?(Proc)
          return data.call(::Tilt::Jbuilder.new(scope))
        else
          file.is_a?(String) ? eval(data, context, file) : eval(data, context)
        end
      end
    end

    private
    def set_locals(locals, scope, context)
      view_path = options[:view_path]
      scope.send(:instance_variable_set, '@_jbuilder_view_path', view_path)
      scope.send(:instance_variable_set, '@_jbuilder_locals', locals)
      scope.send(:instance_variable_set, '@_tilt_data', data)
      set_locals = locals.keys.map { |k| "#{k} = @_jbuilder_locals[#{k.inspect}]" }.join("\n")
      eval set_locals, context
    end
  end

  register Tilt::JbuilderTemplate, 'jbuilder'
end
