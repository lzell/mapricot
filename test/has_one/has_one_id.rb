require 'rubygems'
require '../../lib/mapricot'
require '../../lib/abstract_doc'
require 'spec'

include Mapricot

class FeedWithOneId < Mapricot::Base
  has_one :id,  :integer
end


share_as :HasOneId do 
  
  before(:all) do 
    @feed = FeedWithOneId.new(:xml => "<id>10</id>")
  end
    
  describe "Interface" do 

    it "should have an id of 10" do 
      @feed.id.should == 10
    end
  end
  

  describe "Internals" do 

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
      ass.namespace.should be_nil
      ass.value.should == 10
    end
  end
end


describe "has one id, parsing with hpricot" do 
  before(:all) { Mapricot.use_libxml = false }
  it_should_behave_like HasOneId
end

describe "has one id, parsing with libxml" do 
  before(:all) { Mapricot.use_libxml = true }
  it_should_behave_like HasOneId
end