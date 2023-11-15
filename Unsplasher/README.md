# TrackVia iOS Code Challenge

The original challenge text can be found [here](README-Challenge-Description.md)

## Loading and Testing of this project

* Prerequisites: [ruby](https://github.com/sstephenson/rbenv), [ruby gems](https://rubygems.org/pages/download), [bundler](http://bundler.io)

This project has been setup to use [fastlane](https://fastlane.tools) to run the specs.

Since this project uses a forked version of a CocoaPod, my CocoaPod specs must be added to the top of your `Podfile`:

```
source 'https://github.com/rbaumbach/PublicCocoapodSpecs.git'
```

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

Note: The `Pods` directory is included in the root directory so this project can be run as is.

Double Note: In order to run the application, the Unsplash access key and secret key must be added to the `Constants.swift` file.  The `ConstantTests.swift` file should be updated as well to reflect this update to get all the tests to pass.

## High Level Approach

The stories will be implemented using [Test Driven Development](https://en.wikipedia.org/wiki/Test-driven_development) and test will be able to be run via the command line.

Note: Due to time constraints, while the app will take advantage of constraints to lay out the views, it will be developed with the iPhone 14 Pro in mind.  I will also use `UIKit`, as it is my preferred API to build interfaces quickly.

## Development notes

### Assumptions

After I digested the [original README.md](README-Challenge-Description.md), I went ahead and opened the project and attempted to launch the simulator.  The application would not run, and I discovered that `AppDelegate`, `SceneDelegate` and the `info.plist` were not setup to run the application.  It would have been easy to re-create a project on my own from scratch, I instead spent ~ 1 hr to fix this one.  I did this because I wasn't sure if this was part of the challenge, so I made an assumption it was.

I then I started digesting the documentation for using [the Unsplash Image API](https://unsplash.com/developers).  After reading the API, I noticed that they have an iOS library that pretty much does everything this challenge does. Since the challenge itself didn't discourage the usage of libraries, I pulled it in. Since the library itself had a few quirks, I knew that I would have to fork the repo and make my own changes and publish them.  I thought this was a great exercise to demonstrate my previous SDK/Library/Open Source experience.

### Project

In order to be a good citizen, I used `SwiftLint` to keep some consistency with language patterns.  I also used `fastlane` to run the specs (unit tests) from the command line.

### Image downloading

Image downloading can be a pretty complicated problem.  It requires writing all the code for downloading an image with `URLSession`s, caching them on disk, and finally leveraging `OperationQueue`s for handling the background downloading and main queue UI updates. All the apps in my career at this point have leveraged various open source libraries for this.  Such as:

* `AFNetworking`
* `SD_WebImage`
* `KingFisher`
* etc.

For this project it was no different.  I ended up using `SDWebImage` due to it being an older stable library.  By using this library I was able to save a huge amount of time I would have spent writing the code.

### UI

Since the exercise didn't provide much details on the design of the app, I opted to use the default UI that is given from the Unsplash iOS library.  Since it was pretty straight foward, I added scrolling to the `DetailViewController` images.

### Dependencies

I mentioned using the `SDWebImage` library above, but I want to mention that [I forked the Unsplash iOS library](https://github.com/rbaumbach/unsplash-photopicker-ios).  This was a great way to demonstrate how I can work with unknown codebases to solve problems.

### Specs (Unit Tests)

The code I wrote was unit tested.  There are some tests in `ViewController` and `DetailViewController` that I "punted" on that would require the mocking of `SDWebImage`. This isn't particularly difficult, but for the sake of time, this will be done at a later date.  Some changes are also required in my forked version of the Unsplash iOS library as well, and re-publishing a new version.

### Issues?

There are weird constraint errors given for the scroll view on the `DetailViewController`.  Not sure why, as the scroll view was very basic and configured properly.  Further investigation is needed.

## Final thoughts

I ended up spending ~4 hours of time completing what I have on this challenge.  I was able to:

* Fix the application so that it can be run
* Fork the [original Unsplash iOS library](https://github.com/unsplash/unsplash-photopicker-ios), make custom updates, and publish new versions to my [CocoaPod specs repo](https://github.com/rbaumbach/PublicCocoapodSpecs).
* Leverage the custom forked Unsplash iOS library to fulfill the challenge requirements
* Add zoom functionality to user selected images that was not specified in the challenge requirements
* Write unit tests to verify behavior of the code that was written using Quick and Nimble libraries

## An extended conversation

> I see you used a library to do all the work for you, but what we really wanted was to see you write networking code that can use an external API and implement "infinite scrolling."

Sure, but the challenge itself didn't discourage the usage of libraries so I leveraged the open source community to fulfill my requirements.  This is something that can also be done while working on a real dev team.  If you'd like to see how I approach hooking up to an API using `URLSession`, you [can see how I did this with a previous project](https://github.com/rbaumbach/YabProjz/tree/maestro/Hyperloop).

In regards to infinite scrolling a collection view, I dug into the internals of the Unsplash iOS library.  They actually had a pretty clever solution [using a paging view](https://github.com/rbaumbach/unsplash-photopicker-ios/blob/master/UnsplashPhotoPicker/UnsplashPhotoPicker/Classes/Views/PagingView.swift), and handled the reloading of the collection data source using `OperationQueue`s and a custom `PageDataSource` class. I could have implemented a similar approach (although much simpler) by copying/modifying/simplifying what I seen from that library.  Rather than demonstrate that I can do that, I instead chose to demonstrate that I could leverage completely unknown code and showcase my SDK experience.  This required me to make changes and publish new CocoaPod versions to consume in my app.

> Ok, sure.  But you'd never do this in production.

Well, first of all, this isn't a production app.  This is a challenge that is meant to gauge technical skill (assumption of course).  I decided to use an approach to highlight certain aspects of my experience, and how I would approach a problem if I had freedom.

In regards to wether or not I'd use this in production, it's unlikely, but possible.  If the team encourages quick iterative development, the library could be used to create a releasable version that allows the user to use the application completely.  This would allow, QA, product and other developers to use the application much earlier for feedback.  Since it was implemented so quickly, follow up work/stories/epics can begin to either:

1. Continue to make custom changes to the form of the library
2. Create a brand new version from scratch while not breaking the application

> Anything else?

Since this coding challenge itself gave me the impression that I can have the freedom to code, I took this opportunity to showcase a different set of skills other than the traditional "build this thing." Rather than focus on copying pasting my own networking code from another project and/or being inspired by various "infinite scrolling" solutions from others online, I decided to showcase my overall project experience:

1. That I can work with unknown code quickly
2. Think on my feet to solve a problem quickly
3. Display my open source/library/SDK experience
4. Display my advanced CocoaPod experience
5. Provide insight to unit testing code that is consuming other code

While I understand that this solution might not be what was expected, it demonstrates experience that is potentially overlooked during a dev interview process.
