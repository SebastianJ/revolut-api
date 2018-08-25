RSpec.describe Revolut::Api::Private::Exchange do
  before { setup_configuration }
  let(:client) { Revolut::Api::Client.new }
  
  describe :exchange, vcr: {cassette_name: 'exchange/eur_to_usd'} do
    let(:result) { client.exchange(from: "EUR", to: "USD", amount: 0.1, side: :sell) }
    let(:transactions) { result.fetch(:transactions, []) }
    let(:transaction) { transactions.first }
    
    it { expect { result }.not_to raise_error }
    it { expect(result).to be_a_kind_of Hash }
    it { expect(result.fetch(:status)).to eq :completed }
    it { expect(result.fetch(:success)).to eq true }
    it { expect(result.fetch(:error)).to be_empty }
    
    it { expect(transactions).to be_a_kind_of Array }
    it { expect(transactions.size).to eq 2 }
    it { expect(transaction).to be_a_kind_of ::Revolut::Api::Response::Transaction }
    
    expectations = {
      id:               "EUR-TO-USD-TRANSACTION-ID",
      leg_id:           "EUR-TO-USD-LEG-ID",
      description:      "Exchanged to USD",
      type:             "EXCHANGE",
      state:            "COMPLETED",
      rate:             1.15717505,
      pending?:         false,
      completed?:       true,
      currency:         "EUR",
      amount:           -0.1,
      fee:              0.0,
      balance:          100.0
    }
    
    expectations.each do |key, value|
      it "should have correct value for instance variable #{key}" do
        expect(transaction.send(key)).to eq value
      end
    end
  end
  
  describe :exchange_all, vcr: {cassette_name: 'exchange/all_usd_to_eur'} do
    let(:result) { client.exchange(from: "USD", to: "EUR", amount: :all, side: :sell) }
    let(:transactions) { result.fetch(:transactions, []) }
    let(:transaction) { transactions.first }
    
    it { expect { result }.not_to raise_error }
    it { expect(result).to be_a_kind_of Hash }
    it { expect(result.fetch(:status)).to eq :completed }
    it { expect(result.fetch(:success)).to eq true }
    it { expect(result.fetch(:error)).to be_empty }
    
    it { expect(transactions).to be_a_kind_of Array }
    it { expect(transactions.size).to eq 2 }
    it { expect(transaction).to be_a_kind_of ::Revolut::Api::Response::Transaction }
    
    expectations = {
      id:               "ALL-USD-TO-EUR-TRANSACTION-ID",
      leg_id:           "ALL-USD-TO-EUR-LEG-ID",
      description:      "Exchanged to EUR",
      type:             "EXCHANGE",
      state:            "COMPLETED",
      rate:             0.8553219,
      pending?:         false,
      completed?:       true,
      currency:         "USD",
      amount:           -0.11,
      fee:              0.0
    }
    
    expectations.each do |key, value|
      it "should have correct value for instance variable #{key}" do
        expect(transaction.send(key)).to eq value
      end
    end
  end
  
end
