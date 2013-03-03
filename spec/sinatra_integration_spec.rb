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
  
  it "renders instance variables" do
    jbuilder_app { @last_name = "Smith"; jbuilder "json.last_name @last_name" }
    body.should == "{\"last_name\":\"Smith\"}"
  end

  it "renders helper methods" do
    jbuilder_app { jbuilder "json.is_admin admin?" }
    body.should == "{\"is_admin\":false}"
  end

  it "renders partials with local variables" do
    jbuilder_app { jbuilder "json.partial! :partial_with_local_variable, last_name: \"Smith\"" }
    body.should == "{\"last_name\":\"Smith\"}"
  end

  it "renders partials with instance variables" do
    jbuilder_app { @last_name = "Smith"; jbuilder "json.partial! :partial_with_instance_variable" }
    body.should == "{\"last_name\":\"Smith\"}"
  end

  it "renders partials with helper methods" do
    jbuilder_app { jbuilder "json.partial! :partial_with_helper_method" }
    body.should == "{\"is_admin\":false}"
  end
end
