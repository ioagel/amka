# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2023-05-14

### Added

- New `validate` method that returns detailed validation errors
- New `validate!` method that raises exceptions with descriptive messages
- Added `safe_valid?` method to Luhn class for exception-free validation
- Improved error handling with specific `ValidationError` class

### Changed

- Improved `valid?` method to never raise exceptions
- Refactored validation logic for better maintainability
- Better error messages for validation failures

### Fixed

- Rubocop compliance for method length

## [2.0.0] - 2025-04-16

### Changed

- Updated minimum Ruby version to 2.7.0
- Migrated from Minitest to RSpec for testing
- Modernized gem infrastructure
- Added GitHub Actions for CI
- Added SimpleCov for test coverage
- Improved documentation

### Security

- Added MFA requirement for gem publishing
- Updated development dependencies

## [1.0.1] - 2015-10-15

### Added

- Initial release
