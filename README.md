## Analytics tool

### Overview

### Prerequisites

- Ruby `2.3.0` (`rbenv` is a good ruby version manager)
- Bundler (`gem install bundler`)
- Redis (`brew install redis`)

### Run locally

After cloning this repo, run at the root:
- `bundle install`

### Run test suite

`rspec --require spec_helper`

### Known improvements

#### `total_spend` feature

- keep only 2 digits afer dot (readibility)

### Technical choices justifications

Frameworks:
- Rspec: fast to spin up a simple tests suite, `MiniTest` is good as well
- Figaro:

Misc:
- Architecture: layers style, modular as much as possible to enable extension
- Tests coverage:
