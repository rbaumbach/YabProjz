# Hyperloop

The original challenge text can be found [here](og.txt)

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

As described, the development of the app will be scoped to approximately 4 hours.  This means that potentially more stories will be created that will not be completed before the time limit. Basic user facing features will be prioritized to allow for potential releasing after each code update.

Note: Due to time constraints, while the app will take advantage of constraints to lay out the views, it will be developed with the iPhone 14 in mind.  I will also use `UIKit`, as it is my preferred API to build interfaces quickly.

## Development notes

### Project

In order to be a good citizen, I used `SwiftLint` to keep some consistency with language patterns.  I also used `fastlane` to run the specs (unit tests) from the command line.

### Networking

Since the Imgur API was pretty basic for fetching galleries, I was able to leverage code that I've written on another side project.  This cut down drastically on the amount of time required to build the application.  I was also able to use my "Network Service" pattern I enjoy using.

I treated the `APIClient` code itself like a "dependency."  This means that I didn't write specs for it.

However, the Imgur API documentation for some of the JSON payloads itself wasn't very clear.  I had to spend a significant amount of time manually making queries using `Postman` to figure out the different values for some of the key/value pairs.

### Image downloading

Image downloading can be a pretty complicated problem.  It requires writing all the code for downloading an image with `URLSession`s, caching them on disk, and finally leveraging `OperationQueue`s for handling the background downloading and main queue UI updates. All the apps in my career at this point have leveraged various open source libraries for this.  Such as:

* `AFNetworking`
* `SD_WebImage`
* `KingFisher`
* etc.

For this project it was no different.  I ended up using `SD_WebImage` due to it being an older stable library.  By using this library I was able to save a huge amount of time I would have spent writing the code.

### Debouncer

I knew I wanted the search bar to make "on the fly" API calls for the images based on typing rather than wait for a user to hit a "done" button.  I knew it could be expensive to make API calls after each letter, and would lead to a bad experience without a debouncer.  I have an open source library of various tools called `Utensils`, so I added this dependency to get access to a debouncer.  After some quick trial and error, I settled on a debouncing time of `0.3` seconds.

### UI

Since the exercise didn't provide much details on the design of the app, I opted to create the simplest UI for the use cases in an effort to demonstrate an effective MVP (Minimum Viable Product) that could be iterated on quickly with design updates in the future.

### Specs (Unit Tests)

I've fully tested all the models, custom views, extensions, `ImgurNetworkService` and view controllers.

### Issues?

There are werid constraint errors given for the scroll view.  Not sure why, as the scroll view was very basic and configured properly.  Further investigation is needed.

## Final thoughts

I ended up spending ~5 hours of actual development time completing what I have on this project.  I was able to:

1. Create a view that lists all the images a user searches for using the first page of the Imgur API.
2. Allow the user to tap on an image to see a detailed view of the image.
3. Allow the user to zoom in on a detailed view of the image.

I was able to fully complete stories 1-4.  I begun the work for the 5th story, and was unable to start the 6th.

Some issues that I ran into that required a significant amount of time were:

* Digesting the Imgur API
* Spiking (Experimenting) on MVP UI for quick release and follow up iterations
* Brushing up on some `UIKit` controls that I haven't use in a while such as a `SearchController` and `UIScrollView`.

While I sped through this exercise to get in as much as I could within the time frame, I don't think I would have done anything differently.  Now, on to searching for more Chihuahua images!

## Update

In a follow up conversation, I was asked to make the `DetailViewController` swipeable.  In other words, the same image will be displayed when tapped from the `MainViewController`, but swiping left will show the previous image, and swiping right will show the next image.  In an effort to distinquish between my previous work and this new requirement, I will create a new view controller that is identical to the current controllers, and then make changes so that the previous work can still be shown.  Then a new view controller will be added that gives the user a choice as to which flow to use.
