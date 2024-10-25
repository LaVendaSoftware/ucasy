# Ucasy

Description soon!

## Installation

Add this line to your application's Gemfile:

```ru
gem "ucasy", "~> 0.2.0"
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
bundle add ucasy
```

## Create base file

You can use a Rails generator to create setup `UseCaseBase` file:

```sh
rails g ucasy:install
```

This will create `app/use_cases/use_case_base.rb`

```rb
class UseCaseBase < Ucasy::Base
  class Flow < Ucasy::Flow
  end
end
```

## Basic usage

You can create a simple use case to `app/use_cases/authenticate_user.rb`:

```rb
class AuthenticateUser < UseCaseBase
  def before
    context.user = User.find_by(login: context.login)
  end

  def call
    return if context.user.valid_password?(context.password)

    context.fail!(
      status: :unprocessable_entity,
      message: "User not found",
      errors: context.user.errors
    )
  end

  def after
    UserMailer.with(user: context.user).login_warning.perform_later
  end
end
```

## Using methods

There is some methods to ensure arguments for each use case:

### required_attributes

```rb
class AuthenticateUser < UseCaseBase
  required_attributes(:login, :password)

  def call
    context.login
    context.password
  end
end
```

The method `required_attributes` raises an error if `login` or `password` is blank


### validate

You can use ActiveModel or any class that respond to `valid?`, `errors`, `present?` and accepts a hash as arguments to validate you payload.

Create a class

```rb
class AuthenticateUser < UseCaseBase
  validate(AuthenticateUserValidation)

  def call
    context.login
    context.password
  end
end
```

Adds a validation

```rb
class AuthenticateUserValidation
  include ActiveModel::Model

  attr_accessor :login, :password

  validates :login, presence: true
  validates :password, presence: true

  def to_context
    {login:, :password} # this hash will be injected in use cases context
  end
end
```

## Using Flow

You can also create a flow to organize your use cases:

```rb
class PlaceOrder < UseCaseBase::Flow
  transactional # if any use case fails ActiveRecord will rollback transaction

  validate(PlaceOrderValidation)

  flow(ChargeCard, SendThankYou, FulfillOrder)
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ucasy.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
