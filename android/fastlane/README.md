fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android test

```sh
[bundle exec] fastlane android test
```

Run Flutter tests

### android internal

```sh
[bundle exec] fastlane android internal
```

Deploy to Google Play internal testing track

### android beta

```sh
[bundle exec] fastlane android beta
```

Deploy to Google Play beta (open testing) track

### android production

```sh
[bundle exec] fastlane android production
```

Deploy to Google Play production track

### android promote_to_beta

```sh
[bundle exec] fastlane android promote_to_beta
```

Promote internal track to beta

### android promote_to_production

```sh
[bundle exec] fastlane android promote_to_production
```

Promote beta track to production

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
