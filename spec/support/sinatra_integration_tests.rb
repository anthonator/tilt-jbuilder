  def sinatra_integration_tests
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

  it "renders partials with local variables and non-Sinatra-application scope" do
    jbuilder_app { jbuilder "json.partial! :partial_with_local_variable, last_name: \"Smith\"", :scope => Object.new }
    body.should == "{\"last_name\":\"Smith\"}"
  end

  it "renders partials multiple times" do
    lambda do
      2.times do
        jbuilder_app { jbuilder "json.partial! :partial_with_local_variable, last_name: \"Smith\"" }
      end
    end.should_not raise_error
  end
end