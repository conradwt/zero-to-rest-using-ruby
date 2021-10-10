# Zero to REST Using Rails

The purpose of this example is to provide details as to how one would go about using REST with the Rails Web Framework. Thus, I have created two major sections which should be self explanatory: Quick Installation and Tutorial Installation.

## Getting Started

## Software requirements

- PostgreSQL 14.0 or newer

- Rails 6.1.4.1 or newer

- Ruby 3.0.2 or newer

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/rails). (Tag 'rails')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/rails).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Quick Installation

1.  clone this repository

    ```zsh
    git clone git@github.com:conradwt/zero-to-rest-using-rails.git
    ```

2.  change directory location

    ```zsh
    cd zero-to-rest-using-rails
    ```

3.  install dependencies

    ```zsh
    bundle install
    ```

4.  update the `host`, `username`, `password` settings which appear at the top of the following file(s):

    ```text
    config/database.yaml
    ```

5.  create, migrate, and seed the database

    ```zsh
    rails db:setup
    ```

6.  start the server

    ```zsh
    rails s
    ```

7.  navigate to our application within the browser

    ```zsh
    open http://localhost:3000
    ```

## Tutorial Installation

1.  create the project

    ```zsh
    rails new zero-rails -d postgresql -T --no-rc --api
    ```

2.  rename the project directory

    ```zsh
    mv zero-rails zero-to-rest-using-rails
    ```

3.  switch to the project directory

    ```zsh
    cd zero-to-rest-using-rails
    ```

4.  update Ruby gem dependencies

    ```zsh
    bundle add active_model_serializers
    bundle add rack-cors
    ```

5.  config CORS by adding the following text after within the `config/initializers/cors.rb` file:

    ```ruby
    Rails.application.config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'

        resource '*',
                headers: :any,
                methods: %i[get post put patch delete options head]
      end
    end
    ```

6.  update the `host`, `username`, and `password` settings within `config/database.yml` file:

    replace

    ```yml
    default: &default
      adapter: postgresql
      encoding: unicode
      # For details on connection pooling, see Rails configuration guide
      # https://guides.rubyonrails.org/configuring.html#database-pooling
      pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
    ```

    with

    ```yml
    default: &default
      adapter: postgresql
      encoding: unicode
      # For details on connection pooling, see Rails configuration guide
      # https://guides.rubyonrails.org/configuring.html#database-pooling
      pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
      host: <%= ENV.fetch("POSTGRES_HOST") { 'localhost' } %>
      username: <%= ENV.fetch("POSTGRES_USER") { 'postgres' } %>
      password: <%= ENV.fetch("POSTGRES_PASSWORD") { 'password' } %>
    ```

7.  create the database

    ```zsh
    rails db.create
    ```

8.  generate an API for representing our `Person` resource

    ```zsh
    rails g scaffold person first_name last_name username email --api --no-assets
    ```

9.  migrate the database

    ```zsh
    rails db:migrate
    ```

10. put our `PeopleController` within a proper namespace called `API`

    a) update `config/initializers/inflections.rb` lines 14 - 16 to the following:

    ```ruby
    ActiveSupport::Inflector.inflections(:en) do |inflect|
      inflect.acronym 'API'
    end
    ```

    Note: For an example, [please see](https://github.com/conradwt/zero-to-rest-using-rails/config/initializers/inflections.rb).

    b) update `config/routes.rb` by replacing `resources :people` with the following:

    ```ruby
    namespace :api do
      resources :people
    end
    ```

    Note: For an example, [please see](https://github.com/conradwt/zero-to-rest-using-rails/config/routes.rb).

    c) create a directory called `api` within the `app/controllers` folder

    ```zsh
    mkdir -p app/controllers/api
    ```

    d) move the file, `app/controllers/people_controller.rb`

    ```zsh
    mv app/controllers/people_controller.rb app/controllers/api/people_controller.rb
    ```

    e) wrap the contents `app/controllers/api/people_controller.rb` inside a module

    ```ruby
    module API
      #  our existing code goes here
    end
    ```

    Note: For an example, [please see](https://github.com/conradwt/zero-to-rest-using-rails/app/controllers/api/people_controller.rb).

11. generate a `Friendship` model which representing our join model:

    ```zsh
    rails g model friendship person:references friend:references
    ```

12. replace `t.references :friend, foreign_key: true`, within migration file,
    `<some-timestamp>_create_friendships_rb` file with the following:

    ```ruby
    t.references :friend, index: true
    ```

13. migrate the database

    ```zsh
    rails db:migrate
    ```

14. replace the generated `Person` model with the following:

    ```ruby
    class Person < ApplicationRecord
      has_many :friendships, dependent: :destroy
      has_many :friends, through: :friendships
    end
    ```

15. replace the generated `Friendship` model with the following:

    `web/models/friendship.ex`:

    ```ruby
    class Friendship < ApplicationRecord
      belongs_to :person
      belongs_to :friend, class_name: 'Person'
    end
    ```

    Note: We want `friend_id` to reference the `people` table because our `friend_id` really represents a `Person` model.

16. update the contents of the seeds file to the following:

    `db/seeds`:

    ```ruby
    # reset the datastore
    Person.destroy_all

    # insert people
    me = Person.create!(first_name: 'Conrad',
                        last_name: 'Taylor',
                        email: 'conradwt@gmail.com',
                        username: 'conradwt')
    dhh = Person.create!(first_name: 'David',
                        last_name: 'Heinemeier Hansson',
                        email: 'dhh@37signals.com',
                        username: 'dhh')
    ezra = Person.create!(first_name: 'Ezra',
                          last_name: 'Zygmuntowicz',
                          email: 'ezra@merbivore.com',
                          username: 'ezra')
    matz = Person.create!(first_name: 'Yukihiro',
                          last_name: 'Matsumoto',
                          email: 'matz@heroku.com',
                          username: 'matz')

    me.friendships.create!(person_id: me.id, friend_id: matz.id)

    dhh.friendships.create!(person_id: dhh.id, friend_id: ezra.id)
    dhh.friendships.create!(person_id: dhh.id, friend_id: matz.id)

    ezra.friendships.create!(person_id: ezra.id, friend_id: dhh.id)
    ezra.friendships.create!(person_id: ezra.id, friend_id: matz.id)

    matz.friendships.create!(person_id: matz.id, friend_id: me.id)
    matz.friendships.create!(person_id: matz.id, friend_id: ezra.id)
    matz.friendships.create!(person_id: matz.id, friend_id: dhh.id)
    ```

17. seed the database

    ```zsh
    rails db:seed
    ```

18. start the server

    ```zsh
    rails s
    ```

19. navigate to our application within the browser

    ```zsh
    open http://localhost:3000
    ```

## Production Setup

Ready to run in production? Please [check our deployment guides](https://guides.rubyonrails.org/configuring.html).

## Rails References

- Official website: https://rubyonrails.org
- Guides: https://guides.rubyonrails.org
- Docs: https://api.rubyonrails.org
- Mailing list: https://groups.google.com/forum/#!forum/rubyonrails-talk
- Source: https://github.com/rails/rails

## Support

Bug reports and feature requests can be filed with the rest for the Phoenix project here:

- [File Bug Reports and Features](https://github.com/conradwt/zero-to-rest-using-rails/issues)

## License

Zero to Restful API Using Phoenix is released under the [MIT license](https://mit-license.org).

## Copyright

copyright:: (c) Copyright 2021 Conrad Taylor. All Rights Reserved.
