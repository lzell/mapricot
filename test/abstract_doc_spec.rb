require 'rubygems'
require 'spec'
require '../lib/abstract_doc'

include Mapricot

describe AbstractDoc do 
  it "should initialize from url or string" do 
    AbstractDoc.should respond_to(:from_string)
    AbstractDoc.should respond_to(:from_url)
  end

  describe "in action" do 
    before(:all) do 
      doc = AbstractDoc.from_string %(<user>bob</user>)
      @users = doc.find(:user)
    end
    
    it "should provide a common interface for finding tags" do
      @users.should be_a(AbstractNodeList)
    end
    
    it "should provide a common interface for finding tag contents" do
      @users.first.should_not be_nil
      @users.each do |user|
        user.should be_a(AbstractNode)
        user.contents.should == "bob"
        user.to_s.should == "<user>bob</user>"
      end
    end
  end
end

