# Simple News

A small Rails newsroom. Anyone can browse the front page. Reading a full story, or publishing one, requires an account. Roles come in a later commit.

## Setup

Install Ruby 3.3.4. That version is pinned in `.ruby-version`.

From this directory:

```sh
bundle install
bin/rails db:prepare
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000).

## Tests

```sh
bin/rails test
```
