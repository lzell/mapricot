require 'rubygems'
require 'spec'
require '../../lib/mapricot'

include Mapricot

class FeedWithOneUser < Mapricot::Base
  has_one :user
end


share_as :HasOneUser do 
  
  before(:all) do 
    @feed = FeedWithOneUser.new(:xml => "<user>bob</user>")
  end

  describe "Interface" do

    it "should have a user 'bob'" do 
      @feed.user.should == "bob"
    end
  end

  describe "Internals" do

    it "should have an accessor on user" do 
      @feed.should respond_to(:user)
    end

    it "should have a class instance variable @association_list, an array of HasMany and HasOne *instances*" do
      @feed.class.association_list.should be_a(Array)
      ass_template = @feed.class.association_list.first
      ass_template.should be_a(HasOneAssociation)
      ass_template.name.should == :user
      ass_template.type.should == :string
      ass_template.namespace.should   be_nil
      ass_template.value.should       be_nil
    end

    it "should have an instance variable @associations, duplicated from class ivar @association_list, with value now set" do
      @feed.instance_variable_get(:@associations).should be_a(Array)
      ass = @feed.instance_variable_get(:@associations).first
      ass.should be_a(HasOneAssociation)
      ass.name.should == :user
      ass.type.should == :string
      ass.namespace.should  be_nil
      ass.value.should == "bob"
    end
  end
end


describe "has one user, parsing with hpricot" do 
  before(:all) { Mapricot.use_libxml = false }
  it_should_behave_like HasOneUser
end

describe "has one user, parsing with libxml" do 
  before(:all) { Mapricot.use_libxml = true }
  it_should_behave_like HasOneUser
end