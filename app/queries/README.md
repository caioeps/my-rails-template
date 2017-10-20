# Query objects

This type of classes responsible for collection items based on different
conditions. To **prevent** lookup methods in models like this:

```ruby
class Project
  def issues_for_user_filtered_by(user, filter)
    # A lot of logic not related to project model itself
  end
end

issues = project.issues_for_user_filtered_by(user, params)
```

Better use this:

```ruby
class Issues::ByProjectAndUserQuery
  def initialize(project:, user:, filter: nil)
    @filter  = filter
    @project = project
    @user    = user
  end

  def execute
    # Lots of magic
  end
end

Issues::ByProjectAndUserQuery.new(project: project, user: user, filter: filter)
```
It will help keep models ~much more~ thinner and your queries become more
testable..

You can still use scopes in your model since they don't violate the the Law Of
Demeter. Just keep in mind, scopes are usually there only to help Query Objects.

### Chainable query object

```ruby
class ProjectQuery
  attr_reader :project, :relation

  def initialize(project)
    @project  = project
    @relation = Project.where(nil)
  end

  def with_users(users)
    relation = relation.where(user: users)
    self
  end

  def without_activities
    # Complex logic to handle the query, and then return self.
    self
  end

  private

  attr_writer :relation
end

# You'd then call chain it like so:
ProjectQuery.new(project).with_users(User.limit(5)).without_activities.relation
```
