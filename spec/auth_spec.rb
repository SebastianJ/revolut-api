RSpec.describe Revolut::Api::Private::Auth do
  # Signin attempts must use the same device id
  before { Revolut::Api.configuration.device_id = "f12b16ba-a0f5-4598-aa7d-554391f45ebe" }
  
  let(:client) { Revolut::Api::Client.new }
  
  describe :signin, vcr: {cassette_name: 'auth/signin'} do
    it { expect { client.signin(phone: "+1555555555", password: "9999") }.not_to raise_error }
    # Could possibly test that a phone number received the text message from Revolut (using for example TextNow), but meh.
  end
  
  describe :confirm_signin, vcr: {cassette_name: 'auth/confirm_signin'} do
    let(:response) { client.confirm_signin(phone: "+1555555555", code: "213372") }
    
    it { expect { response }.not_to raise_error }
    it { expect(response).to be_a_kind_of Hash }
    it { expect(response).to have_key(:id) }
    it { expect(response).to have_key(:access_token) }
    it { expect(response.fetch(:access_token)).to eq "ACCESS_TOKEN" }
  end
  
end
