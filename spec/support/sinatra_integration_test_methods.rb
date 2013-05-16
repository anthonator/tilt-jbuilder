module SinatraIntegrationTestMethods
  def jbuilder_app(&block)
    @app = Sinatra.new(Sinatra::Base) do
      set :views, File.dirname(__FILE__) + "/views"
      helpers do
        def admin?; false end
      end
      get("/", &block)
    end
    get "/"
  end

  def app
    Rack::Lint.new(@app)
  end

  def body
    last_response.body.to_s
  end
end
