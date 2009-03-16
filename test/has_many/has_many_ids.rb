require 'rubygems'
require 'spec'
require '../../lib/mapricot'

include Mapricot

class ResponseWithManyIds < Mapricot::Base
  has_many :ids,  :integer
end


share_as :HasManyIds do 
  
  before(:all) do 
    @response = ResponseWithManyIds.new(:xml => %(
      <response>
        <id>10</id>
        <id>20</id>
        <id>30</id>
      </response>
    ))
  end
    
  describe "Interface" do 

    it "should have an array of ids" do 
      @response.ids.should be_a(Array)
      @response.ids[0].should == 10
      @response.ids[1].should == 20
      @response.ids[2].should == 30
    end
  end
  

  describe "Internals" do 
  
    it "should have an accessor on ids" do
      @response.should respond_to(:ids)
    end
  
    it "should have a class instance variable @association_list" do
      ass_template = @response.class.association_list.first
      ass_template.name.should == :ids
      ass_template.type.should == :integer
      ass_template.namespace.should   be_nil
      ass_template.value.should       be_nil
    end
  
    it "should have an instance variable @associations, duplicated from class ivar @association_list, with value now set" do
      ass = @response.instance_variable_get(:@associations).first
      ass.name.should == :ids
      ass.type.should == :integer
      ass.namespace.should be_nil
      ass.value.should == [10,20,30]
    end
  end
end


describe "has many ids, parsing with hpricot" do 
  before(:all) { Mapricot.use_libxml = false }
  it_should_behave_like HasManyIds
end

describe "has many id, parsing with libxml" do 
  before(:all) { Mapricot.use_libxml = true }
  it_should_behave_like HasManyIds
end