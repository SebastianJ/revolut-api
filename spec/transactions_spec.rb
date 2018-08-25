RSpec.describe Revolut::Api::Private::Transactions do
  before { setup_configuration }
  let(:client) { Revolut::Api::Client.new }
  
  describe :transactions, vcr: {cassette_name: 'transactions/all'} do
    let(:transactions) { client.transactions(fetch_all: false, memoize: false) }
    let(:transaction) { transactions.first }
    
    it { expect { transactions }.not_to raise_error }
    it { expect(transactions).to be_a_kind_of Array }
    it { expect(transaction).to be_a_kind_of ::Revolut::Api::Response::Transaction }
    
    expectations = {
      id:               "transaction-id-111111",
      leg_id:           "leg-id-111111",
      description:      "Coinbase",
      rate:             10,
      type:             "CARD_PAYMENT",
      state:            "PENDING",
      pending?:         true,
      currency:         "EUR",
      amount:           -10.0,
      fee:              0.0
    }
    
    expectations.each do |key, value|
      it "should have correct value for instance variable #{key}" do
        expect(transaction.send(key)).to eq value
      end
    end
    
    merchant_expectations = {
      id:               "11111",
      scheme:           "MASTERCARD",
      name:             "Coinbase",
      country:          "US",
      city:             "San Francisco",
      address:          "Some address 1",
      postcode:         "111111",
      mcc:              "1234",
      category:         "crypto"
    }
    
    merchant_expectations.each do |key, value|
      it "should have correct value for instance variable #{key} for the merchant" do
        expect(transaction.merchant.send(key)).to eq value
      end
    end
    
  end
end
