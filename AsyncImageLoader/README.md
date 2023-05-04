# AsyncImageLoader

A workplace that demonstrates different ways to load images asynchronously on iOS.

## Goal

I've been asked this question twice already in a month during live coding exercises, and I figure that I'd spend the time doing some experiments.  The goal is to try different ways to load these images, and when I see something that I think looks good, build it using TDD.

Note: In an production app, I would rely on battle tested libraries such as [SDWebImage](https://github.com/SDWebImage/SDWebImage) instead of trying to homeroll this functionality.  It's a complex enough topic with a lot of edge case bugs that have been resolved with these libraries.  They also handle the persistence of the cache to disk as well.

## Version 1

This is the hackest quickest solution that came to mind.  Create an extension on `UIImageView` and add a method to this class that will set the image of the `UIImageView`.  The trickest part was handling the lack of dataTask cancelling when a user scrolls past the cell before the image has been downloaded.  An additional property was needed on `UIWebImage` that could keep a url as a "tag" that could be checked to see if the cell is no longer visible.  If it's not, then we don't set the image.  It also uses a global `NSCache` to store the images.

In order to add a property to `UIImageView` I used some Objective-C dynamic-ness with `objc_get/setAssociatedObject` functions.

Pros:

* Quick to write
* Easy to use
* Easy to read

Cons:

* Uses Objective-C dynamic magic
* Is difficult to test (if at all)
* Has a global `NSCache`
* Doesn't cancel images currently downloading if the cell is no longer in view and has been recycled

## Version 2

This version was an enhanced version of `Version 1`.  Rather than adding a property to `UIImageView` using `get/setAssociatedObject` functions, a subclass of `UIImageView` called `AsyncImageView`.

Pros:

* Quick to write
* Easy to use
* Easy to read
* Easy to test

Cons:

* The subclass must be used instead of the standard `UIImageView`
* Composition over inheritance
* Has a global `NSCache`
* Doesn't cancel images currently downloading if the cell is no longer in view and has been recycled

## Version 3

This version was definitely the most complex.  Rather than "hacking" around the issue of cells being recycled before the image is downloading and throwing them away, I decided to implement an image fetch and cancelling implementation called `AsyncImageFetcher`.  When a user scrolls through the cells, if the cells are recycled before the image has been fetched, the image download is cancelled. The cancellation logic uses a dictionary that tags an `URLSessionDataTask` with a uuid that can be retrieved.  The `AsyncImageFetcher` also owns the instance of `NSCache` that is used to cache the images that have been downloaded.

It is also required that the custom `ArticleTableViewCell` subclass have an `onReuse` function that gets called when the cell is about to be recycled.

Pros:

* Saves phone resources by implementing image download cancelling
* Is testable
* No global variables
* No subclassing `UIView`s

Cons:

* Definitely a complex implemenation
* Harder to read
* Must hook in `onReuse` method in `UITableViewDataSource` methods if needed

## Final TDD'd solution

After looking at all the evidence of approach I decied on Version 3.  Using what I learned from Version 3, I re-implemented this solution using TDD.