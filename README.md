# Revolut::Api

Revolut::Api is a Ruby gem to interact with Revolut's unofficial and internal API.

This is the actual API used by the iOS/Android apps and not the business API.

I've reverse engineered the API by checking what endpoints are invoked using [Charles Proxy](https://www.charlesproxy.com).

This API is subject to change at any time and you should obviously take care using this client since it could result in loss of funds in your Revolut account.

Hopefully Revolut will release an official API for the personal app and not just for Revolut Business.

_NOTE: I do not take any responsibility of loss of funds or similar issues due to using this client!_

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'revolut-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install revolut-api

## Usage

### Public client

If you just want to use the public client to check exchange rates:

```ruby
public_client = Revolut::Api::Public::Client.new
public_client.quotes(from: "EUR,USD", to: "SEK")
```

You can also check quotes for cryptocurrencies:

```ruby
public_client = Revolut::Api::Public::Client.new
public_client.quotes(from: "BTC,ETH,LTC,XRP", to: "USD")
```

### Private/authenticated client

#### Authentication

In order to use the private/authenticated endpoints of Revolut's API you need to sign in first using your phone number and your PIN/password:

```ruby
client = Revolut::Api::Client.new
client.signin(phone: "+1555555555", password: "1337")
```

After invoking this method Revolut will send you a text message with a code to confirm your sign in attempt. When you've received this code (which is valid for 10 minutes), do the following:

```ruby
client.confirm_signin(phone: "+1555555555", code: "CODE_RECEIVED_FROM_REVOLUT")
=> {:id=>"YOUR-USER-ID", :access_token=>"YOUR-ACCESS-TOKEN"}
```

If the call is successful you should receive a hash containing your user id and your access token.

If you haven't configured the device id the library will automatically generate one using `SecureRandom.uuid`. I'd also suggest saving this id and use it for configuring subsequent API calls using the client:

```ruby
Revolut::Api.configuration.device_id
=> "SOME-RANDOM-DEVICE-GUID"
```

Update your configuration file (e.g. an initializer if you're using Rails) for setting up Revolut::API:

```ruby
Revolut::Api.configure do |config|
  config.user_id          =   "YOUR-USER-ID"
  config.access_token     =   "YOUR-ACCESS-TOKEN"
  config.device_id        =   "SOME-RANDOM-DEVICE-GUID"
end
```

This way you don't have to sign in / confirm your sign in next time you want to interact with the API.

Verify that you can call endpoints that require correct authorization:

```ruby
client.user
=> #<Revolut::Api::Response::User:0x00007ff27615eee0
 @address=#<Revolut::Api::Response::Address:0x00007ff27615ed00 @city="Random Town", @country="US", @postcode="111111", @region="REGION", @street_line_one="Epic Street", @street_line_two=nil>,
 @birth_date=[1999, 12, 31],
```

Revolut::Api::AuthorizationError is raised if there are any issues with authorization.

#### User data

##### User details

To get your current Revolut user details:

```ruby
client.user
```

##### Wallet & pockets

```ruby
client.wallet
```

##### Cards

```ruby
client.cards
```

##### Update address

```ruby
client.update_address(city: "New City")
```

#### Transactions

Fetch and memoize all transactions executed the current year:

```ruby
client.transactions(fetch_all: true, memoize: true)
```

Fetch and memoize all completed transfer transactions executed the current year:

```ruby
client.transactions(type: :transfer, completed: true, fetch_all: true, memoize: true)
```

Fetch and memoize all completed card payment transactions executed the current year:

```ruby
client.transactions(type: :card_payment, completed: true, fetch_all: true, memoize: true)
```

Fetch and memoize all pending card payment transactions executed the current year:

```ruby
client.transactions(type: :card_payment, pending: true, fetch_all: true, memoize: true)
```

Fetch a specific transaction by its transaction id:

```ruby
client.transaction("TRANSACTION_ID")
```

#### Exchange

##### Fiat

Exchange 0.1 EUR to USD:

```ruby
client.exchange(from: "EUR", to: "USD", amount: 0.1, side: :sell)
```

Exchange all available USD to EUR:

```ruby
client.exchange(from: "USD", to: "EUR", amount: :all, side: :sell)
```

##### Cryptocurrency

Buy/exchange 10 EUR worth of BTC:

```ruby
client.exchange(from: "EUR", to: "BTC", amount: 10, side: :sell)
```

Buy/exchange 10 EUR worth of LTC:

```ruby
client.exchange(from: "EUR", to: "LTC", amount: 10, side: :sell)
```

Buy/exchange 10 EUR worth of ETH:

```ruby
client.exchange(from: "EUR", to: "ETH", amount: 10, side: :sell)
```

Buy/exchange 10 EUR worth of XRP:

```ruby
client.exchange(from: "EUR", to: "XRP", amount: 10, side: :sell)
```

## Development & Testing

After checking out the repo, run `bin/setup` to install dependencies.

Copy credentials.yml.example to credentials.yml. If you do not already have your user id and an access token, run `bin/console`:

```ruby
client = Revolut::Api::Client.new
client.signin(phone: "+1555555555", password: "1337")
client.confirm_signin(phone: "+1555555555", code: "CODE_RECEIVED_FROM_REVOLUT")
=> {:id=>"YOUR-USER-ID", :access_token=>"YOUR-ACCESS-TOKEN"}
Revolut::Api.configuration.device_id
=> "SOME-RANDOM-DEVICE-GUID"
```

Update credentials.yml with your user id, access token and device id.

You can now run `rake spec` to run the tests.

WARNING: If you delete the VCR cassettes in the spec/fixtures/vcr_cassettes-folder real API calls will be made to Revolut and real data will be returned from Revolut.

For the current test suite this means performing actual exchanges from EUR to USD and exchanging _all_ available USD in your wallet to EUR.

_I repeat: I do not take any responsibility for any loss of funds._

The data returned from Revolut will contain your real user data. You have to manually edit all VCR cassette files and replace your personal/sensitive data with dummy data.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SebastianJ/revolut-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Revolut project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/SebastianJ/revolut-api/blob/master/CODE_OF_CONDUCT.md).
