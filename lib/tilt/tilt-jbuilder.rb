require 'tilt/template'
require 'jbuilder'

module Tilt
  class JbuilderTemplate < Template
    self.default_mime_type = 'application/json'

    def self.engine_initialized?
      defined? ::Jbuilder
    end

    def initialize_engine
      require_template_library 'jbuilder'
    end

    def prepare; end

    def evaluate(scope = Object.new, locals, &block)
      context = scope.instance_eval { binding }
      set_locals(locals, scope, context)
      eval %{
        Jbuilder.encode do |json|
          if @_tilt_data.kind_of? Proc
            return @_tilt_data.call(Jbuilder.new)
          else
            eval @_tilt_data, binding
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
