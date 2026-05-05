# Contributing to AIDLC Sprint Planning

Thank you for your interest in contributing! This document provides guidelines
for contributing to this project.

## How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-change`)
3. Make your changes in `common/` (the single source of truth)
4. Run `bash scripts/copy-common.sh all` to verify the build
5. Commit your changes with a descriptive message
6. Push to your fork and open a Pull Request

## Development Guidelines

- All core logic lives in `common/`. Edit files there, not in the implementation directories.
- Run the build script after every change to verify all three targets build correctly.
- Follow the terminology defined in `common/terminology.md`.
- Review the LLM instruction quality checklist in `.kiro/steering/llm-instruction-review.md`.

## Reporting Issues

- Use GitHub Issues to report bugs or suggest improvements.
- Include which implementation (Power, Skill, or CLI) is affected.
- Describe the expected vs. actual behavior.

## Code of Conduct

This project follows the [Amazon Open Source Code of Conduct](https://aws.github.io/code-of-conduct).

## Licensing

See the [LICENSE](LICENSE) file for details. By submitting a pull request, you
confirm that you can use, modify, copy, and redistribute your contribution,
under the terms of your choice.
