# Decorators

A decorator adds an OO layer of presentation logic to your view.

Without decorators, this functionality might have been tangled up in procedural
helpers or bloating your models.

With decorators, you can wrap your models with presentation-related
logic to organise - and test - this layer of your app much more effectively.

## Why Use a Decorator?

Imagine your application has an `Article` model. You'd create a
corresponding `ArticleDecorator`. The decorator wraps the model, and deals
*only* with presentational concerns. In the controller, you decorate the article
before handing it off to the view:

```ruby
# app/controllers/articles_controller.rb
def show
  @article = Article.find(params[:id])
  @artice_decorator = ArticleDecorator.new(@article)
end
```

In the view, you can use the decorator in exactly the same way as you would have
used the model. But whenever you start needing logic in the view or start
thinking about a helper method, you can implement a method on the decorator
instead.

Let's look at how you could convert an existing Rails helper to a decorator
method. You have this existing helper:

```ruby
# app/helpers/articles_helper.rb
def publication_status(article)
  if article.published?
    "Published at #{article.published_at.strftime('%A, %B %e')}"
  else
    "Unpublished"
  end
end
```

But it makes you a little uncomfortable. `publication_status` lives in a
nebulous namespace spread across all controllers and view. Down the road, you
might want to display the publication status of a `Book`. And, of course, your
design calls for a slightly different formatting to the date for a `Book`.

Now your helper method can either switch based on the input class type (poor
Ruby style), or you break it out into two methods, `book_publication_status` and
`article_publication_status`. And keep adding methods for each publication
type...to the global helper namespace. And you'll have to remember all the names. Ick.

Ruby thrives when we use Object-Oriented style. If you didn't know Rails'
helpers existed, you'd probably imagine that your view template could feature
something like this:

```erb
<%= @article.publication_status %>
```

Without a decorator, you'd have to implement the `publication_status` method in
the `Article` model. That method is presentation-centric, and thus does not
belong in a model.

Instead, you implement a decorator:

```ruby
# app/decorators/article_decorator.rb
class ArticleDecorator < ApplicationDecorator
  def publication_status
    if object.published?
      "Published at #{published_at}"
    else
      "Unpublished"
    end
  end

  def published_at
    object.published_at.strftime("%A, %B %e")
  end
end
```

Within the `publication_status` method we use the `published?` method. Where
does that come from? It's a method of the  source `Article`, whose methods have
been made available on the decorator by the `delegate_all` call above.

You might have heard this sort of decorator called a "presenter", an "exhibit",
a "view model", or even just a "view" (in that nomenclature, what Rails calls
"views" are actually "templates"). Whatever you call it, it's a great way to
replace procedural helpers like the one above with "real" object-oriented
programming.

Decorators are the ideal place to:
* format complex data for user display
* define commonly-used representations of an object, like a `name` method that
  combines `first_name` and `last_name` attributes
* mark up attributes with a little semantic HTML, like turning a `url` field
  into a hyperlink


### Read more about the Decorator pattern
[https://github.com/infinum/rails-handbook/blob/master/Design%20Patterns/Decorators.md](https://github.com/infinum/rails-handbook/blob/master/Design%20Patterns/Decorators.md)
[https://thepugautomatic.com/2014/03/draper/](https://thepugautomatic.com/2014/03/draper/)

