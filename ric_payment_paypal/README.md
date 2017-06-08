# RicPaymentPaypal

## PayPal account

- Log in at the site https://developer.paypal.com
- Go to "My Apps & Credentials" and create a new app in "REST API Apps section
- Retrieve Client ID and Secret for Sandbox and Live environments

## Gemfile

Following gems must be added to application Gemfile:

```ruby
gem "paypal-sdk-rest"
```

And of course gem of Ric modules:

```ruby
gem "ric_payment"
gem "ric_payment_paypal"
```

## Configuration

