RSpec.describe Revolut::Api::Private::User do
  before { setup_configuration }
  let(:client) { Revolut::Api::Client.new }
  
  describe :user, vcr: {cassette_name: 'user/current'} do
    let(:user) { client.user }
    
    it { expect { user }.not_to raise_error }
    it { expect(user).to be_a_kind_of ::Revolut::Api::Response::User }
    
    expectations = {
      id:               -> { Revolut::Api.configuration.user_id },
      created_date:     Time.new(2018, 8, 24, 20, 49, 40, 0),
      first_name:       "Satoshi",
      last_name:        "Nakamoto",
      phone:            "+1555555555",
      active?:          true,
    }
    
    expectations.each do |key, value|
      it "should have correct value for instance variable #{key}" do
        value = value.call if value.respond_to?(:call)
        expect(user.send(key)).to eq value
      end
    end
  end
  
  describe :wallet, vcr: {cassette_name: 'user/wallet'} do
    let(:wallet) { client.wallet }
    
    it { expect { wallet }.not_to raise_error }
    it { expect(wallet).to be_a_kind_of ::Revolut::Api::Response::Wallet }
    
    expectations = {
      id:               "wallet-12345",
      ref:              "111111111",
      state:            "ACTIVE",
      base_currency:    "EUR",
      total_topup:      100.0
    }
    
    expectations.each do |key, value|
      it "should have correct value for instance variable #{key}" do
        expect(wallet.send(key)).to eq value
      end
    end
    
    it { expect(wallet.pocket("EUR").balance).to eq 100.0 }
  end
  
  describe :cards, vcr: {cassette_name: 'user/cards'} do
    let(:cards) { client.cards }
    let(:card) { cards.first }
    
    it { expect { cards }.not_to raise_error }
    it { expect(cards).to be_a_kind_of Array }
    
    expectations = {
      id:               "card-id-1",
      owner_id:         -> { Revolut::Api.configuration.user_id },
      last_four:        1337,
      brand:            "visa",
      expiry_date:      {month: 1, year: 2028},
    }
    
    expectations.each do |key, value|
      it "should have correct value for instance variable #{key}" do
        value = value.call if value.respond_to?(:call)
        expect(card.send(key)).to eq value
      end
    end
    
    it { expect(card.issuer.name).to eq "BITCONE BANK" }
  end
  
  describe :update_address do
    context :updating_address, vcr: {cassette_name: 'user/update/updating'} do
      it { expect { client.update_address(city: "San Francisco") }.not_to raise_error }
    end
    
    context :updated_address, vcr: {cassette_name: 'user/update/updated'} do
      let(:user) { client.user }
      
      it { expect { user }.not_to raise_error }
      it { expect(user.address.city).to eq "San Francisco" }
    end
  end
  
end
