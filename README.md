# Simple News

A small Rails newsroom. Guests can browse the front page and the story index. Reading a full story requires an account. Editors publish and maintain their own stories. Admins manage accounts and roles, and they do not publish.

## Stack

- Ruby 3.3.4, Rails 8.1
- SQLite
- Devise for accounts
- Petergate for roles (`user`, `editor`, `admin`)
- Slim templates
- Minitest

## Setup

Install Ruby 3.3.4. That version is pinned in `.ruby-version`.

From this directory:

```sh
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

`bundle install` installs the gems in the `Gemfile`. `db:prepare` creates the SQLite database and runs migrations. `db:seed` loads the demo accounts and stories.

`bin/setup` does those three steps and then starts the app.

Open [http://localhost:3000](http://localhost:3000).

## Demo accounts

Every seeded account uses the password `password123`.

| Email | Role | Can do |
| --- | --- | --- |
| reader@example.com | Reader (`user`) | Read full stories |
| editor@example.com | Editor | Publish, edit, and delete only their own stories |
| admin@example.com | Admin | Create accounts and change roles. Cannot publish, edit, or delete stories |

Signup always creates a reader. An admin assigns editor and admin from People.

## Tests

```sh
bin/rails test
```
