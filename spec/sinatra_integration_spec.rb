require "tilt"
require "tilt/jbuilder"
require "sinatra/jbuilder"

require "rack/test"
require "sinatra/base"

ENV['RACK_ENV'] ||= "test"
Sinatra::Base.set :environment,  :test

module SinatraIntegrationTestMethods
  def jbuilder_app(&block)
    @app = Sinatra.new(Sinatra::Base) do
      set :views, File.dirname(__FILE__) + "/views"
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

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include SinatraIntegrationTestMethods
end

describe "Sinatra Integration" do
  it "renders inline jbuilder strings" do
    jbuilder_app { jbuilder "json.author 'Anthony'" }
    body.should == "{\"author\":\"Anthony\"}"
  end

  it "renders .jbuilder files in views path" do
    jbuilder_app { jbuilder :hello }
    body.should == "{\"author\":\"Anthony\"}"
  end

  it "renders partial" do
    jbuilder_app { jbuilder "json.partial! :hello" }
    body.should == "{\"author\":\"Anthony\"}"
  end
end
