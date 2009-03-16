require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../lib/abstract_doc")


include Mapricot


share_examples_for "an abstract xml parser" do 
  
  it "should initialize from a url or a string" do 
    AbstractDoc.should respond_to(:from_string)
    AbstractDoc.should respond_to(:from_url)
  end
  
  it "should be using libxml or hpricot or nokogiri" do
    puts "using #{Mapricot.parser}..."
    [:libxml, :hpricot, :nokogiri].include?(Mapricot.parser).should be_true
  end

  describe "creating a document from a string of xml" do 
    before(:all) do 
      @doc = AbstractDoc.from_string %(<user>bob</user>)
    end
    
    it "should be able to find all the <user> nodes" do 
      @doc.find(:user).should_not be_nil
    end
    
    describe "the list of user nodes" do
      
      before(:all) do 
        @user_nodes = @doc.find(:user)
      end
      
      it "should be an abstract node list" do 
        @user_nodes.should be_a(AbstractNodeList)
      end

      it "should be able to iterate over" do
        @user_nodes.should respond_to(:each)
        @user_nodes.should respond_to(:first)
        @user_nodes.should respond_to(:[])
      end
      
      describe "the first user node" do
        
        before(:all) do 
          @user = @user_nodes.first
        end
        
        it "should be a abstract node" do
          @user.should be_a(AbstractNode)
        end
        
        it "should be able to get the node contents" do
          @user.contents.should == "bob"
          @user.to_s.should == "<user>bob</user>"
        end
      end
    end
  end
end

describe "AbstractDoc using libxml" do 
  before(:all) { Mapricot.parser = :libxml }
  it_should_behave_like "an abstract xml parser"
end

describe "AbstractDoc useing hpricot" do 
  before(:all) { Mapricot.parser = :hpricot }
  it_should_behave_like "an abstract xml parser"
end

describe "AbstractDoc useing hpricot" do 
  before(:all) { Mapricot.parser = :nokogiri }
  it_should_behave_like "an abstract xml parser"
end

