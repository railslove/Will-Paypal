require "spec_helper"

describe "PaypalNVP" do
  
  describe "initialize" do
    
    context "overwriting defaults" do
      subject { PaypalNvp.new(:version => "1").config[:version] }
      it { should == "1" }
    end
    
    context "with defaults" do
      subject { PaypalNvp.new }
      
      its(:config) do 
        should eql({
          :version => "50.0",
          :sandbox => false,
          :url => "",
          :params => {}
        })
      end
      
    end
  end
  
  describe "Request to Paypal" do
    
    describe "Query String" do
      
      let(:paypal) { PaypalNvp.new }
      
      it "should create a valid querystring from request params" do
        paypal.query_string_for({ :foo => "bar", :bar => "foo" }).should == "FOO=bar&BAR=foo&USER=&PWD=&SIGNATURE="
      end
      
      %w{user pwd signature}.each do |param|
        it "should include #{param} by default" do
          paypal.query_string_for({}).should include("#{param.to_s.upcase}=#{URI.escape(paypal.config[param.to_sym].to_s)}")
        end
      end

    end
    
  end
  
  describe "Paypal response" do
    
    let(:paypal) { PaypalNvp.new }
    
    it "should convert a query string like" do
      paypal.hash_from_query_string("FOO=bar&BAR=foo&SIGNATURE=123456").should eql({
        "FOO" => "bar", "BAR" => "foo", "SIGNATURE" => "123456"
      })
    end
    
    it "should remove blank attributes" do
      paypal.hash_from_query_string("FOO=bar&BAR=foo&USER=&PWD=&SIGNATURE=123456").should eql({
        "FOO" => "bar", "BAR" => "foo", "SIGNATURE" => "123456"
      })
    end
    
  end

end