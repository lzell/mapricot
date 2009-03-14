require 'rubygems'
require 'spec'
require '../lib/mapricot'
require '../lib/abstract_doc'

class FeedWithOneUser < Mapricot::Base
  has_one :user
  
  def initialize
    super(:xml => "<user>bob</user>")
  end
end

describe FeedWithOneUser do
  before(:all) do 
    @feed = FeedWithOneUser.new
  end

  it "should have an accessor on user" do 
    @feed.should respond_to(:user)
  end
  
  it "should have a class instance variable @association_list, an array of HasMany and HasOne *instances*" do
    @feed.class.association_list.should be_a(Array)
    ass_template = @feed.class.association_list.first
    ass_template.should be_a(Mapricot::HasOneAssociation)
    ass_template.name.should == :user
    ass_template.type.should == :string
    ass_template.namespace.should   be_nil
    ass_template.value.should       be_nil
  end
  
  it "should have an instance variable @associations, duplicated from class ivar @association_list, with value now set" do
    @feed.instance_variable_get(:@associations).should be_a(Array)
    ass = @feed.instance_variable_get(:@associations).first
    ass.should be_a(Mapricot::HasOneAssociation)
    ass.name.should == :user
    ass.type.should == :string
    ass.namespace.should  be_nil
    ass.value.should == "bob"
  end
  
  it "should return 'bob'" do
    @feed.user.should == "bob"
  end
end



class FeedWithOneId < Mapricot::Base
  has_one :id,  :integer
  
  def initialize
    super(:xml => "<id>10</id>")
  end
end


describe FeedWithOneId do 
  before(:all) do
    @feed = FeedWithOneId.new
  end
  
  it "should have an accessor on id" do
    @feed.should respond_to(:id)
  end

  it "should have a class instance variable @association_list" do
    ass_template = @feed.class.association_list.first
    ass_template.name.should == :id
    ass_template.type.should == :integer
    ass_template.namespace.should   be_nil
    ass_template.value.should       be_nil
  end
  
  it "should have an instance variable @associations, duplicated from class ivar @association_list, with value now set" do
    ass = @feed.instance_variable_get(:@associations).first
    ass.name.should == :id
    ass.type.should == :integer
    ass.namespace.should  be_nil
    ass.value.should == 10
  end
  
  it "should return 10" do
    @feed.id.should == 10
  end
end