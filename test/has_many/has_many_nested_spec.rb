require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/mapricot")

include Mapricot

class ResponseWithNesting < Mapricot::Base
  has_many :users, :xml
end

class User < Mapricot::Base
  has_one :id,    :integer
  has_one :name
end


share_as :HasManyNested do 
  
  before(:all) do 
    @response = ResponseWithNesting.new(:xml => %(
      <response>
        <user>
          <id>10</id>
          <name>bob</name>
        </user>
        <user>
          <id>20</id>
          <name>sally</name>
        </user>
      </response>
    ))
  end
    
  describe "Interface" do 

    it "should have bob as the first user" do 
      @response.users.first.id.should == 10
      @response.users.first.name.should == "bob"
    end
    
    it "should have sally as the second user" do
      @response.users.last.id.should == 20
      @response.users.last.name.should == "sally"
    end
  end
  

  describe "Internals" do 
  
    it "should have an accessor on users" do
      @response.should respond_to(:users)
    end
  
    it "should have a class instance variable @association_list" do
      ass_template = @response.class.association_list.first
      ass_template.name.should == :users
      ass_template.type.should == :xml
      ass_template.namespace.should   be_nil
      ass_template.value.should       be_nil
    end
  
    it "should have an instance variable @associations, duplicated from class ivar @association_list, with value now set" do
      ass = @response.instance_variable_get(:@associations).first
      ass.name.should == :users
      ass.type.should == :xml
      ass.namespace.should be_nil
      ass.value.should_not be_nil  # should not
    end
    
    describe "its users" do 

      before(:all) do 
        @users = @response.users
      end

      it "should be a an array of User objects, a subclass of Mapricot::Base" do
        @users.should be_a(Array)
        @users.first.should be_a(User)
        @users.first.should be_a(Mapricot::Base)
      end

      it "should have a class instance variable @association_list, an array of HasMany and HasOne *instances*" do
        ass_template = @users.first.class.association_list.first
        ass_template.should be_a(HasOneAssociation)
        ass_template.name.should == :id
        ass_template.type.should == :integer
        ass_template.namespace.should   be_nil
        ass_template.value.should       be_nil
      end

      it "should have an instance variable @associations, duplicated from class ivar @association_list, with value now set" do
        ass = @users.first.instance_variable_get(:@associations).first
        ass.name.should == :id
        ass.type.should == :integer
        ass.namespace.should  be_nil
        ass.value.should == 10
      end
    end
  end
end


describe "has many ids, parsing with hpricot" do 
  before(:all) { Mapricot.use_libxml = false }
  it_should_behave_like HasManyNested
end

describe "has many id, parsing with libxml" do 
  before(:all) { Mapricot.use_libxml = true }
  it_should_behave_like HasManyNested
end