# Policies objects

Policies objects are made for authorization or just checking conditionals.
Policies objects don't change anything in the database, just read the
informations in it.

```ruby
class PostPolicy
  attr_reader :user, :post

  def initialize(post:, user:)
    @post = post
    @user = user
  end

  def update?
    user.admin? || !post.published?
  end

  def emailable?
    # Very complex logic to check if the post must be sent to users emails.
  end
end

PostPolicy.new(user: current_user, post: post).update?
PostPolicy.new(post: post).emailable?
```
