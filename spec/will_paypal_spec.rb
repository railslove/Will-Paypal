require "spec_helper"

describe "WillPaypal" do

  describe "initialize" do

    context "overwriting defaults" do
      subject { WillPaypal.new(:version => "1").config[:version] }
      it { should == "1" }
    end

    context "with defaults" do
      subject { WillPaypal.new }

      its(:config) do
        should eql({
          :version => "72.0",
          :sandbox => false,
          :url => "https://api-3t.paypal.com/nvp",
          :params => {}
        })
      end

    end
  end

  describe "Converting query strings back and forth" do
    let(:paypal) { WillPaypal.new }
    it 'should succeed' do
      hash = {'NAME' => 'Barnes & Noble', 'TITLE' => 'Barnes and Noble'}
      convertible = paypal.hash_from_query_string(paypal.query_string_for(hash))
      convertible['NAME'].should eql(hash['NAME'])
      convertible['TITLE'].should eql(hash['TITLE'])
    end
  end

  describe "Request to Paypal" do

    describe "Query String" do

      let(:paypal) { WillPaypal.new }

      it "should create a valid querystring from request params" do
        %w{FOO=bar BAR=foo USER= PWD= SIGNATURE=}.each do |a|
          paypal.query_string_for({ :foo => "bar", :bar => "foo" }).should include (a)
        end
      end

      %w{user pwd signature}.each do |param|
        it "should include #{param} by default" do
          paypal.query_string_for({}).should include("#{param.to_s.upcase}=#{URI.escape(paypal.config[param.to_sym].to_s)}")
        end
      end

    end

  end

  describe "Paypal response" do

    let(:paypal) { WillPaypal.new }

    it "should convert a query string like" do
      paypal.hash_from_query_string("FOO=bar&BAR=foo&SIGNATURE=123456").should eql({
        "FOO" => "bar", "BAR" => "foo", "SIGNATURE" => "123456"
      })
    end

    it "should remove blank attributes" do
      paypal.hash_from_query_string("FOO=bar&BAR=foo&USER=&PWD=&SIGNATURE=123456&VERSION=72.0").should eql({
        "FOO" => "bar", "BAR" => "foo", "SIGNATURE" => "123456", "VERSION" => "72.0"
      })
    end

  end

  describe "Paypal Call" do

    context "success" do
      let(:paypal) { WillPaypal.new(:user => "team_1220115929_biz_api1.example.com", :pass => "1240413944", :cert => "acert4qi4-AdHZBSIbxJNpN30UcsogreatcertP", :version => "72.0") }

      it "should return the successful response" do
        response_data = "TIMESTAMP=2011%2d05%2d18T17%3a51%3a55Z&CORRELATIONID=f45a2a3867a2b&ACK=Success&VERSION=72%2e0&BUILD=1882144&L_ERRORCODE0=10002&L_SHORTMESSAGE0=Authentication%2fAuthorization%20Failed&L_LONGMESSAGE0=You%20do%20not%20have%20permissions%20to%20make%20this%20API%20call&L_SEVERITYCODE0=Error"
        FakeWeb.register_uri(:post, %r|https://api-3t.paypal.com/nvp|, :body => response_data, :times => 1)
        paypal.call_paypal({}).should eql({:status => "200", :body => response_data, :parsed_body => {"L_SEVERITYCODE0"=>"Error", "TIMESTAMP"=>"2011-05-18T17:51:55Z", "L_ERRORCODE0"=>"10002", "BUILD"=>"1882144", "L_LONGMESSAGE0"=>"You do not have permissions to make this API call", "VERSION"=>"72.0", "L_SHORTMESSAGE0"=>"Authentication/Authorization Failed", "CORRELATIONID"=>"f45a2a3867a2b", "ACK"=>"Success"}})
      end
    end

    context "ssl" do
      let(:paypal) { WillPaypal.new(:user => "team_1220115929_biz_api1.example.com", :pass => "1240413944", :cert => "acert4qi4-AdHZBSIbxJNpN30UcsogreatcertP", :version => "72.0") }

      it "should do an ssl call" do
        response_data = "TIMESTAMP=2011%2d05%2d18T17%3a51%3a55Z&CORRELATIONID=f45a2a3867a2b&ACK=Failure&VERSION=72%2e0&BUILD=1882144&L_ERRORCODE0=10002&L_SHORTMESSAGE0=Authentication%2fAuthorization%20Failed&L_LONGMESSAGE0=You%20do%20not%20have%20permissions%20to%20make%20this%20API%20call&L_SEVERITYCODE0=Error"
        FakeWeb.register_uri(:post, %r|https://api-3t.paypal.com/nvp|, :body => response_data, :times => 1)
        File.should_receive(:directory?).with('/etc/ssl/certs').and_return(true)
        http = double("Net::HTTP")
        Net::HTTP.stub(:new).and_return(http)
        http_response = double("response")
        http_response.should_receive(:code)
        http_response.should_receive(:body)
        http.should_receive(:request_post).with("/nvp", "PWD=&SIGNATURE=&USER=team_1220115929_biz_api1.example.com&VERSION=72.0").and_return(http_response)
        http.should_receive(:use_ssl=).with(true)
        http.should_receive(:verify_mode=).with(OpenSSL::SSL::VERIFY_PEER)
        http.should_receive(:ca_path=).with('/etc/ssl/certs')
        http.should_receive(:verify_depth=).with(5)
        paypal.call_paypal({})
      end

    end

    context "without ssl" do
      let(:paypal) { WillPaypal.new(:user => "team_1220115929_biz_api1.example.com", :pass => "1240413944", :cert => "acert4qi4-AdHZBSIbxJNpN30UcsogreatcertP", :version => "72.0") }

      it "should do an ssl call" do
        response_data = "TIMESTAMP=2011%2d05%2d18T17%3a51%3a55Z&CORRELATIONID=f45a2a3867a2b&ACK=Failure&VERSION=72%2e0&BUILD=1882144&L_ERRORCODE0=10002&L_SHORTMESSAGE0=Authentication%2fAuthorization%20Failed&L_LONGMESSAGE0=You%20do%20not%20have%20permissions%20to%20make%20this%20API%20call&L_SEVERITYCODE0=Error"
        FakeWeb.register_uri(:post, %r|https://api-3t.paypal.com/nvp|, :body => response_data, :times => 1)
        File.should_receive(:directory?).with('/etc/ssl/certs').and_return(false)
        http = double("Net::HTTP")
        Net::HTTP.stub(:new).and_return(http)
        http_response = double("response")
        http_response.should_receive(:code)
        http_response.should_receive(:body)
        http.should_receive(:use_ssl=).with(true)
        http.should_receive(:request_post).with("/nvp", "PWD=&SIGNATURE=&USER=team_1220115929_biz_api1.example.com&VERSION=72.0").and_return(http_response)
        http.should_receive(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)
        paypal.call_paypal({})
      end
    end

  end

end