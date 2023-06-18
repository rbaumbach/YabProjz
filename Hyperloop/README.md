# Hyperloop

## Loading and Testing of this project

* Prerequisites: [ruby](https://github.com/sstephenson/rbenv), [ruby gems](https://rubygems.org/pages/download), [bundler](http://bundler.io)

This project has been setup to use [fastlane](https://fastlane.tools) to run the specs.

First, run the following commands to bundle required gems and install [Cocoapods](https://cocoapods.org) when in the project directory:

```bash
$ bundle install
$ bundle exec pod repo update
$ bundle exec pod install
```

And then use fastlane to run all the specs on the command line:

```bash
$ bundle exec fastlane specs
```

## High Level Approach

The high level approach for this project is to iteratively build an app that allows a user to search for an image using [Imgur API](https://apidocs.imgur.com).  Basically this means that I use [vertical slicing](https://www.agilerant.info/vertical-slicing-to-boost-software-value/) to develop the application in small consumable pieces that can be reviewed by potential teammates and project stakeholders.

The breakdown of the iterative [vertically sliced](https://www.agilerant.info/vertical-slicing-to-boost-software-value/) development strategy can be found in the [Stories directory](Stories/).  The idea is to mimic a typical project management tool with pointed stories.

The stories will be implemented using [Test Driven Development](https://en.wikipedia.org/wiki/Test-driven_development) and test will be able to be run via the command line.

As described, the development of the app will be scoped to 4 hours.  This means that potentially more stories will be created that will not be completed before the time limit. Basic user facing features will be prioritized to allow for potential releasing after each code update.