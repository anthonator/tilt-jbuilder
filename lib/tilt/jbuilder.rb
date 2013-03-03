require 'jbuilder'

module Tilt
  class Jbuilder < ::Jbuilder
    def initialize(scope, *args, &block)
      @scope = scope
      super(*args, &block)
    end

    def partial!(options, locals = {})
      locals.merge! :json => self
      template = ::Tilt::JbuilderTemplate.new(fetch_partial_path(options.to_s))
      template.render(@scope, locals)
    end

    private
    def fetch_partial_path(file)
      view_path =
        if defined?(::Sinatra) && @scope.respond_to?(:settings)
          @scope.settings.views
        else
          ::Dir.pwd
        end
      ::Dir[::File.join(view_path, partialized(file) + ".{*.,}jbuilder")].first
    end

    def partialized(path)
      partial_file = path.split("/")
      partial_file[-1] = "_#{partial_file[-1]}" unless partial_file[-1].start_with?("_")
      partial_file.join("/")
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
      context = scope.instance_eval { binding }
      set_locals(locals, scope, context)
      klass = ::Tilt::Jbuilder
      eval %{
        if defined? json
          if @_tilt_data.kind_of? Proc
            return @_tilt_data.call(klass.new(scope))
          else
            eval @_tilt_data, binding
          end
        else
          klass.encode(scope) do |json|
            if @_tilt_data.kind_of? Proc
              return @_tilt_data.call(klass.new(scope))
            else
              eval @_tilt_data, binding
            end
          end
        end
      }, context
    end

    private
    def set_locals(locals, scope, context)
      scope.send(:instance_variable_set, '@_jbuilder_locals', locals)
      scope.send(:instance_variable_set, '@_tilt_data', data)
      set_locals = locals.keys.map { |k| "#{k} = @_jbuilder_locals[#{k.inspect}]" }.join("\n")
      eval set_locals, context
    end
  end

  register Tilt::JbuilderTemplate, 'jbuilder'
end

