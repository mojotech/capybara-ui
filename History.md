# Version 1.3.0

### Changed

* Update keyword argument usage in `node_filter` to resolve deprecation warnings in Ruby 2.7 and errors in Ruby 3.0.0 (Thanks, @thomasbalsloev!)
* Add `rexml` to the gem bundle to support Ruby 3.0.0

# Version 1.2.0

### Changed

* Drop support for cucumber < 2.0

# Version 1.1.0

### Fixed

* Don't bomb when rspec is absent

# Version 1.0.3

### Changed

* Dropped support for capybara < 3.0

# Version 1.0.2

### Changed

* Improved error messages for matchers

### Fixed

* Correctly detect rspec even when it is loaded after capybara-ui
* Fix a bug with ListWidget that triggered undesired capybara polling

# Version 1.0.1

### Fixed

* Correctly detect the rspec version by requiring rspec/expectations

# Version 1.0.0
