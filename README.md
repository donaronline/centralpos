# Centralpos [![Build Status](https://travis-ci.org/donaronline/centralpos.svg?branch=master)](https://travis-ci.org/donaronline/centralpos)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'centralpos'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install centralpos

## Setup

You should first configure the WSDL endpoints (Sandbox & Production), by doing:

```ruby
Centralpos.setup do |config|
  config.sandbox_wsdl_endpoint = 'https://sandbox.example.com?wsdl'
  config.production_wsdl_endpoint = 'https://production.example.com?wsdl'
end
```

In a Rails environment make sense to place this in an initializer.

## Usage

In order to use this gem you must already have an account in [Centralpos](http://centralpos.com). Once you have it you can do the following:

  - [Initialize and Account](#initialize-and-account)
  - [Ask about Batches](#ask-about-batches)
  - [Do stuff with an open Batch - Transactions](#do-stuff-with-an-open-batch---transactions)

### Initialize an Account

Load the **Account** with the `"username"` and `"password"`, in order to ask for the batches and everything:

```ruby
account = Centralpos::Account.new("username", "password")
```

now that you have the `account` you can ensure that the credentials are valid calling,

```ruby
account.valid?
```

or ask for the cards that you are able to process with Centralpos,

```ruby
account.enabled_cards
```

### Ask about Batches

With an `account` loaded and `valid?` you can now ask about the open batches that this account has at the moment. Remember that this batches are the only one that accept new transactions to be process later on,

```ruby
open_batches = account.open_batches # returns an Array of Centralpos::Batch instances
```

Or if you already have the batch **ID** you can ask directly about it,

```ruby
batch = account.batch(id) # returns a Centralpos::Batch instance
```

If you want to know all the past batches, that are not open, you can ask them by,

```ruby
past_batches = account.past_batches # returns an Array of Centralpos::Batch instances
```


### Do stuff with an open Batch - Transactions

With an `open_batch` loaded we can start adding, removing or updating transactions to it, in order to process them afterwards. And also check the transactions that are already present in it

Let's create a transaction first, for this we have to pass the parameters as arguments to initialize it:

```ruby
transaction_params = {
    owner_id: "owner_id1",
    cc_number: "4111111111111111",
    amount: 100.0,
}
transaction = Centralpos::Transaction.new(transaction_params)
```

> IMPORTANT: The value of **:owner_id** can only appear once in a **batch** and this value it is the one that is being use to remove a **transaction** from an open **batch**.

There are also to optional values that you can pass to the transaction, this are:

```ruby
transaction_params = transaction_params.merge({
    optional_data_1: "",
    optional_data_2: ""
})
```

So now with a `valid` transaction (yes you can call to `transaction.valid?` or `transaction.invalid?`) you can add it to the open batch,

```ruby
open_batch.add_transaction(transaction)
```

and maybe because you make a mistake you want to remove a transaction of a open batch, to do it you have to remember that the value that it's used to match the transaction that you want to remove is the **owner_id** in the **transaction** instance, so

```ruby
open_batch.remove_transaction(transaction)
```

You can also be able to update a transaction that it's already in the open batch, and as you can imagine you only can update the **cc_number**, **amount**, **optional_data_1** and **optional_data_2** values of the transaction, so

```ruby
transaction.amount = 250.0
open_batch.update_transaction(transaction)
```

on the back what this is doing is removing the transaction from the open batch and adding it again with the new values, that's why you can't change the **owner_id** value of it.

## TO-DOs:

  - Add tests
  - Add missing methods

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/donaronline/centralpos. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

