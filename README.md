# Simple News

A small Rails newsroom. Anyone can browse the front page. Reading a full story requires an account. Editors publish and maintain their own stories. Admins can read stories and cannot publish. Assigning roles from the app comes in a later commit.

## Setup

Install Ruby 3.3.4. That version is pinned in `.ruby-version`.

From this directory:

```sh
bundle install
bin/rails db:prepare
bin/rails server
```

`bin/rails db:seed` loads the demo accounts and a few stories.

Open [http://localhost:3000](http://localhost:3000).

## Demo accounts

Every seeded account uses the password `password123`.

| Email | Role | Can do |
| --- | --- | --- |
| reader@example.com | Reader | Read full stories |
| editor@example.com | Editor | Publish, edit, and delete only their own stories |
| admin@example.com | Admin | Read stories. Cannot publish, edit, or delete them |

Signup always creates a reader.

## Tests

```sh
bin/rails test
```
