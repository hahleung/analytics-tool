## Analytics tool

### Overview

It's a Ruby app which is responding to several commands.

### Prerequisites

- Ruby `2.3.0` (`rbenv` is a good ruby version manager)
- Bundler (`gem install bundler`)
- Redis (`brew install redis`)

### Run locally

After cloning this repo, run at the root:
- `bundle install`
- `bundle exec figaro install`
- `cp application-example.yml config/application.yml`
- Fill the `config/application.yml` file with the relevant intel

Available commands:
- `ruby app.rb total_spend [EMAIL]`
- `ruby app.rb average_spend [EMAIL]`
- `ruby app.rb most_loyal`
- `ruby app.rb highest_value`
- `ruby app.rb most_sold`

No special configuration is required for `Redis`, make sure it's listening by default on `localhost`, port `6379`.

### Run test suite

`rspec --require spec_helper`

### Technical choices justifications

Language / frameworks:
- `ruby`: most confortable language for now
- `Rspec`: fast to spin up a simple tests suite, `MiniTest` is good as well
- `figaro` gem: easy to use, `dotenv` is good as well

Misc:
- **Architecture**: layers style, modular as much as possible to enable extension
- **Cache strategy**: there are 40k entries for each endpoint, HTTP calls might be expensive, in real life prod, this app might be hit by multiple users, recall 2x40k entries is not suitable. The caching time expiration should be decided with the business (how often this pieces of data are likely to be update?)
- **Tests coverage**: unit test are covering `model` and `service` layers. The `gateway` layer is not tested (external). The `orchestration` layer is not tested due to lack of time (see below).

### Known improvements

- Secure communications to `Redis` instance
- Add Regex for email parsing in the `Orchestrator::Maestro` class
- Create a filtering/sanitizing layer for the orchestration layer: is the email valid / existing? security gatekeeping?
- Extract cache checking
- Open 2 concurrent threads while making calls to `purchases` and `users`
- Cache `most_loyal`, `most_sold`, `highest_value` results
- Refactor `most_loyal`, `most_sold`, `highest_value` logic (sharing the same pattern)
- Craft proper schemas for persistence layer
- Write integration tests for the orchestration layer