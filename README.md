# Breast Screening Reporting

Welcome to the Breast Screening Reporting team's repository!

## Table of Contents

- [Breast Screening Reporting](#breast-screening-reporting)
  - [Table of Contents](#table-of-contents)
  - [Setup](#setup)
    - [Prerequisites](#prerequisites)
    - [Configuration](#configuration)
  - [Usage](#usage)
    - [Testing](#testing)
  - [Design](#design)
  - [Branch naming and Commit messages](#branch-naming-and-commit-messages)
  - [Contacts](#contacts)
  - [Licence](#licence)

## Setup

This should be a frictionless installation process that works on various operating systems (macOS, Linux, Windows WSL) and handles all the dependencies.

Clone the repository (SSH)

```shell
git clone git@github.com:NHSDigital/dtos-breast-screening-reporting.git
```

### Prerequisites

The following software packages, or their equivalents, are expected to be installed and configured:

- [Docker](https://www.docker.com/) container runtime or a compatible tool, e.g. [Podman](https://podman.io/),
- [asdf](https://asdf-vm.com/) version manager,
- [GNU make](https://www.gnu.org/software/make/) 3.82 or later,
- pip package manager for Python

> [!NOTE]<br>
> The version of GNU make available by default on macOS is earlier than 3.82. You will need to upgrade it or certain `make` tasks will fail. On macOS, you will need [Homebrew](https://brew.sh/) installed, then to install `make`, like so:
>
> ```shell
> brew install make
> ```
>
> You will then see instructions to fix your [`$PATH`](https://github.com/nhs-england-tools/dotfiles/blob/main/dot_path.tmpl) variable to make the newly installed version available. If you are using [dotfiles](https://github.com/nhs-england-tools/dotfiles), this is all done for you.

- [GNU sed](https://www.gnu.org/software/sed/) and [GNU grep](https://www.gnu.org/software/grep/) are required for the scripted command-line output processing,
- [GNU coreutils](https://www.gnu.org/software/coreutils/) and [GNU binutils](https://www.gnu.org/software/binutils/) may be required to build dependencies like Python, which may need to be compiled during installation,

> [!NOTE]<br>
> For macOS users, installation of the GNU toolchain has been scripted and automated as part of the `dotfiles` project. Please see this [script](https://github.com/nhs-england-tools/dotfiles/blob/main/assets/20-install-base-packages.macos.sh) for details.

- [Python](https://www.python.org/) required to run Git hooks,
- [`jq`](https://jqlang.github.io/jq/) a lightweight and flexible command-line JSON processor.

### Configuration

Installation and configuration of the toolchain dependencies

```shell
make config
```

## Usage

TODO: We need to make these decisions

### Testing

To run tests on your local branch (these are the same tests that run automatically on commit, and remotely on GitHub)

> ```shell
> make githooks-run
> ```

## Design

TODO: We need to make these decisions

## Branch naming and Commit messages

Branch names must adhere to the following format:

```
<type>/<ticket-number>-<description>
```

Where `<type>` is one of:

```
build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test
```

For example:

```
feat/DSTA-1234-add-a-new-feature
```

Commit messages must adhere to the following format:

```
<ticket-number>: <description>
```

For example:

```
DSTA-1234: add a part of a new feature
```

## Contacts

Contact screening-breast-reporting on Slack

## Licence

Unless stated otherwise, the codebase is released under the MIT License. This covers both the codebase and any sample code in the documentation.

Any HTML or Markdown documentation is [© Crown Copyright](https://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/) and available under the terms of the [Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
