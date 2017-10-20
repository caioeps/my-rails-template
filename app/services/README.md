# Services

What are service objects? In a few words, they are basically the logic of your
app. Any action with a little more complex logic must be a service. Services
will read, handle and create your data.

## When to use a service object?

Some actions in a system warrant a Service Object to encapsulate their
operation. I reach for Service Objects when an action meets one or more of these
criteria:

* The action is complex (e.g. closing the books at the end of an accounting
  period)
* The action reaches across multiple models (e.g. an e-commerce purchase using
  Order, CreditCard and Customer objects)
* The action interacts with an external service (e.g. posting to social
  networks)
* The action is not a core concern of the underlying model (e.g. sweeping up
  outdated data after a certain time period).
* There are multiple ways of performing the action (e.g. authenticating with an
  access token or password). This is the Gang of Four Strategy pattern.
* Clean up callbacks of your model. Your model callbacks must not reach to other
  classes. It is also a bad practice to use after_save. In general nothing good
  come after it and also make your tests much more slower. [Read more](http://samuelmullen.com/2013/05/the-problem-with-rails-callbacks/)

Services should always return objects, with possibly statuses and error
messages. It is a bad practice to just return `true` or `false` to tell how the
service processed.

### How to name a service class

Services classes are never suffixed with Service. It should be an imperative
name. `RegisterUser` is an option. Or maybe `CompletePurchase`.

Although, you may want to namespace your services (recommended). So these
classes would be named `Users::Register` and `Purchases::Complete` respectevely.

### Example
```ruby
class Purchases::Complete
  attr_reader :purchase, :user

  def initialize(purchase:, :user)
    @purchase = purchase
    @user     = user
  end

  def call
    if debit_from_user_credit_card
      notify_user_about_purchase
    else
      # Return errors to users
    end
  end

  private

  def debit_from_user_credit_card
    # Use your payment gateway to debit user.
  end

  def notify_user_about_purchase
    Purchases::Notifier.new(purchase: purchase, user: user).call
  end
end
```

