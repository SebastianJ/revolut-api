RSpec.describe Revolut::Api::Public::Client do
  before { setup_configuration }
  let(:client) { Revolut::Api::Public::Client.new}
  
  describe :quotes, vcr: {cassette_name: 'public/quotes'} do
    let(:quotes) { client.quotes(from: "BTC,ETH,LTC,XRP", to: "USD") }
    let(:quote) { quotes.first }
    
    it { expect(quotes).to be_a_kind_of Array }
    
    expectations = {
      from:   "BTC",
      to:     "USD",
      rate:   6589.0336937937,
    }
    
    expectations.each do |key, value|
      it "should have correct value for instance variable #{key}" do
        expect(quote.send(key)).to eq value
      end
    end
    
  end
end
