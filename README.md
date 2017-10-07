## Analytics tool

### Overview

### Prerequisites

- Ruby `2.3.0` (`rbenv` is a good ruby version manager)
- Bundler (`gem install bundler`)
- Redis (`brew install redis`)

### Run locally

After cloning this repo, run at the root:
- `bundle install`

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

Frameworks:
- `Rspec`: fast to spin up a simple tests suite, `MiniTest` is good as well
- `Figaro`:

Misc:
- Architecture: layers style, modular as much as possible to enable extension
- Cache strategy:
- Tests coverage:

### Known improvements

- Secure communications to `Redis` instance
- Add Regex for email parsing in the `Orchestrator::Maestro` class
- Create a filtering/sanitizing layer for the orchestration layer: is the email valid / existing?
- Extract cache checking
- Open 2 concurrent threads while making calls to `purchases` and `users`
- Cache `most_loyal`, `most_sold`, `highest_value` results
- Refactor `most_loyal`, `most_sold`, `highest_value` logic (sharing the same pattern)
- Craft proper schemas for persistence layer