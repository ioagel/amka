# Contributing to AMKA

Thank you for considering contributing to the AMKA gem! This document outlines the process for contributing to this project.

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

- **Use the GitHub issue tracker** — Check if the bug has already been reported by searching on GitHub under [Issues](https://github.com/ioagel/amka/issues).
- **Use the bug report template** — If you're reporting a bug, be sure to include all the information requested in the bug report template.
- **Provide specific examples** — Include specific steps to reproduce the problem, with example code if possible.
- **Describe the behavior you observed** — What happened? How did it differ from what you expected?
- **Include relevant details** — OS, Ruby version, AMKA gem version, etc.

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion, including completely new features and minor improvements to existing functionality.

- **Use the GitHub issue tracker** — Check if the enhancement has already been suggested by searching on GitHub under [Issues](https://github.com/ioagel/amka/issues).
- **Use the feature request template** — Include as much detail as possible in the template.
- **Provide a clear use case** — Explain why this enhancement would be useful to most AMKA users.

### Pull Requests

- **Fill in the required template**
- **Follow the Ruby style guide**
- **Include tests** — Your patch won't be accepted if it doesn't have tests.
- **Document your changes** — Update any relevant documentation.
- **Include updates to the CHANGELOG.md** file for any user-facing changes.
- **Create feature branches** — Don't ask us to pull from your main branch.

## Development Process

### Setting Up the Development Environment

1. Fork and clone the repository
2. Run `bin/setup` to install dependencies
3. Run `bundle exec rake spec` to run the tests

### Testing

- All tests must pass before a pull request will be accepted
- Write tests for all new functionality
- Run tests using `bundle exec rake spec`
- Check code coverage (we aim for >90%) using `open coverage/index.html` after running tests

### Style Guidelines

- Follow the Ruby style guide:
  - Use 2 spaces for indentation
  - Use snake_case for methods and variables
  - Use CamelCase for classes and modules
  - Add descriptive comments for public methods and classes
- Run `bundle exec rubocop` before submitting to ensure code quality
- Add YARD documentation for new public methods

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests after the first line

## Releasing a New Version

For maintainers only:

1. Update the version number in `lib/amka/version.rb`
2. Update the CHANGELOG.md
3. Run the test suite to make sure everything works
4. Commit changes with message "Bump version to x.y.z"
5. Tag the commit with "vx.y.z"
6. Push to GitHub
7. Run `bundle exec rake release`

## Additional Resources

- [General GitHub documentation](https://help.github.com)
- [GitHub pull request documentation](https://help.github.com/articles/about-pull-requests/)
- [Ruby style guide](https://github.com/rubocop/ruby-style-guide)

Thank you for contributing!
