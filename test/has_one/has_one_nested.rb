require 'rubygems'
require 'spec'
require '../../lib/mapricot'

include Mapricot

class FeedWithNesting < Mapricot::Base
  has_one :user, :xml
end

class User < Mapricot::Base
  has_one :name
end

share_as :HasOneNested do 

  before(:all) do 
    @feed = FeedWithNesting.new(:xml => %(
      <user>
        <name>bob</name>
      </user>
    ))
  end


  describe "Interface" do 

    it "should have a user with the name bob" do
      @feed.user.name.should == "bob"
    end
    
    describe "Internals" do

      it "should have a class instance variable @association_list, an array of HasMany and HasOne *instances*" do
        ass_template = @feed.class.association_list.first
        ass_template.should be_a(HasOneAssociation)
        ass_template.name.should == :user
        ass_template.type.should == :xml
        ass_template.namespace.should   be_nil
        ass_template.value.should       be_nil
      end

      it "should have an instance variable @associations, duplicated from class ivar @association_list, with value now set" do
        ass = @feed.instance_variable_get(:@associations).first
        ass.name.should == :user
        ass.type.should == :xml
        ass.namespace.should  be_nil
        ass.value.should_not  be_nil  # should not
      end

      describe "its user" do 

        before(:all) do 
          @user = @feed.user
        end

        it "should be a User, a subclass of Mapricot::Base" do
          @user.should be_a(User)
          @user.should be_a(Mapricot::Base)
        end

        it "should have a class instance variable @association_list, an array of HasMany and HasOne *instances*" do
          ass_template = @user.class.association_list.first
          ass_template.should be_a(HasOneAssociation)
          ass_template.name.should == :name
          ass_template.type.should == :string
          ass_template.namespace.should   be_nil
          ass_template.value.should       be_nil
        end

        it "should have an instance variable @associations, duplicated from class ivar @association_list, with value now set" do
          ass = @user.instance_variable_get(:@associations).first
          ass.name.should == :name
          ass.type.should == :string
          ass.namespace.should  be_nil
          ass.value.should_not  be_nil  # should not
        end
      end
    end  
  end
end


describe "has one nested, using hpricot" do 
  before(:all) { Mapricot.use_libxml = false }
  it_should_behave_like HasOneNested
end

describe "nested, using libxml" do 
  before(:all) { Mapricot.use_libxml = true }
  it_should_behave_like HasOneNested
end
