# Cuadrado

Cuadrado

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

## Submission of the final project

### 1) Build Tools & Versions Used. Please tell us what version of Xcode, Android Studio, IntelliJ, etc you used to build and test your project, as well as what versions of iOS or Android we should use to evaluate your submission.

* Xcode: `Version 11.2.1 (11B500)`
* Swift: `5.1.2`
* Ruby: `2.6.5`
* Bundler: `2.0.2`
* Cocoapods: `1.8.4`
* Fastlane: `2.137.0`
* iOS: `13.2.2`
* Simulator: `iPhone 11 Pro`

### 2) Your Focus Areas. What area(s) did you focus on when working on the project? The architecture and data flow? The UI? Something else? Please note what you think best exhibits your skills and areas of expertise.

My largest focus is also my biggest strength which is my expertise with Test Driven Development (TDD).  This application was 100% completed using TDD, and various testing techniques such as protocol oriented programing, dependency injection, and mocks/stubs for super fast stateless test running.  You can take a look at all the tests I've written in the `Specs` directory.

I've also spent ample time working out the networking layer using a generic api client using a network service pattern.  This allows for quick and decoupled code that can be expanded on very easily in a team setting, keeps data models more pure (data only, will less logic) and view controllers small.

Another specific area I worked on based on the requirements, was to fetch data on app launch only.  This was accomplished by handling the of fetching employees with a separate app launch view controller, `AppLaunchViewController`.  It handles the success/failure states as well as provides a loading page that eventually passes the result (employees or error) from the network service request to the main view controller.  This keeps the state of loading on the app launch view controller, which in effect keeps the main view controller small with minimal state to manage.

Finally, due to the requirements given for this exercise to handle various states of malformed data (no RESTFul API contract), I've decided to manually manage and parse my own JSON.  This can be controversial to some, but it allows for maximum flexibility handling simple or complex malformed data.  It also keeps this logic out of the basic employee model that I wanted to use.

### 3) Copied-in code or copied-in dependencies. We’re obviously looking to evaluate your skills as an engineer! As such, please tell us which code you’ve copied into your project so we can distinguish between code written for this project, versus code written at another time, or by others (if you’re just referencing a dependency via a dependency manager, no need to call it out here).

My dependencies for my application can be found in the `Gemfile` and `Podfile`.  Specifically the Cocoapods I used are:

* SDWebImage: `5.3.2`
* Quick: `2.2.0`
* Nimble: `8.0.4`

Note: `Quick` is the testing framework I used and `Nimble` is the matcher framework.  These frameworks are vastly more superior to what Apple gives you with `XCTest`.

Additional Note: While I could have rolled my own image retrieval and caching layer, I decided to use one of the battle tested libraries I've used in the past, `SDWebImageView`.  By default it caches images on disk from a url for a week.  In this exercise I enabled "never expire" mode on the `SDWebImage` library and saved a bunch of time by not re-inventing the wheel.  The images themselves are saved on disk at: `/Library/Caches/com.hackemist.SDImageCache/default/` in the bundle.

### 4) Tablet / phone focus. If you focused on one or the other of tablet or phone, please let us know which one.

In order to scope the project reasonably, I primarily focused on the iPhone X Pro.  It matches the latest 3 (non-plus) phones, the X, XS in terms of screen size.  I did construct this app using auto layout leveraging safe areas, so while it might not look great on other devices since I didn't specify any differences with size classes, it will run fine.

### 5) How long you spent on the project. We’d like to know how long you spent on the project so we can calibrate our review. Please do not feel like you need to spend more than the expected 4-5 hours.

From the moment that I got the link for this exercise, the time it took to sit down and digest the requirements, planning and finally TDD'ing the entire application, it took about ~9 hours total.  While the expected time was 4-5 hours, this is the minimum time necessary for "enterprise/production" quality code that would be opened in a pull-request to merge into master.

### 6) Anything else you want us to know. If there’s anything else of note that you think we should know while evaluating the project, please let us know!

I would like to mention that I took the phrase, `Treat the code as if you’re merging it to master in a real app.` very seriously.  There was not one single decision in this project where I didn't follow strict test driven development processes.  As I stated in the previous question, if any of the requirements/items were user stories, this would be the quality of code you'd receive from me in a pull request to merge into master.
