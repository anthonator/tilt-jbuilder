require 'spec_helper'

describe Tilt::JbuilderTemplate do
  it "should be registered for '.jbuilder' files" do
    Tilt::JbuilderTemplate.should == Tilt['test.jbuilder']
  end

  it "should evaluate the template on #render" do
    template = Tilt::JbuilderTemplate.new { "json.author 'Anthony'" }
    "{\"author\":\"Anthony\"}".should == template.render
  end

  it "can be rendered more than once" do
    template = Tilt::JbuilderTemplate.new { "json.author 'Anthony'" }
    3.times { "{\"author\":\"Anthony\"}".should == template.render }
  end

  it "should pass locals" do
    template = Tilt::JbuilderTemplate.new { "json.author name" }
    "{\"author\":\"Anthony\"}".should == template.render(Object.new, :name => 'Anthony')
  end

  it "should evaluate in an object scope" do
    template = Tilt::JbuilderTemplate.new { "json.author @name" }
    scope = Object.new
    scope.instance_variable_set :@name, 'Anthony'
    "{\"author\":\"Anthony\"}".should == template.render(scope)
  end

  it "should evaluate block style templates" do
    template = Tilt::JbuilderTemplate.new do |json|
      lambda do |json|
        json.author 'Anthony'
        json.target!
      end
    end
    "{\"author\":\"Anthony\"}".should == template.render
  end

  it "should evaluate partials" do
    template = Tilt::JbuilderTemplate.new { "json.partial! 'spec/partial', last_name: 'Smith'" }
    "{\"last_name\":\"Smith\"}".should == template.render
  end

  it "should evaluate partials with view_path" do
    template = Tilt::JbuilderTemplate.new(nil, nil, view_path: 'spec') { "json.partial! '/partial', last_name: 'Smith'" }
    "{\"last_name\":\"Smith\"}".should == template.render
  end
end
