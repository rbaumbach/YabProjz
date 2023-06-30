# Quotes

This is a simple exercise of displaying quotes from a [Quotes API](https://zenquotes.io) in a `UITableView` with dynamic `UITableViewCell` text sizing.

![Challenge Image](quotes.png)

## Challenge Introduction

I was given 25 minutes[^1] to build an iOS app from scratch using any resource necessary to achieve the exercise goals described above.  I was given two URLs:

1. [Quote API documentation](https://docs.zenquotes.io/zenquotes-documentation/)
2. A sample JSON response that was "minified" and required a tool like "JSONPretty" to digest.

The completed code can be found in the [OnTheFly](OnTheFly/) directory of this repo.

## Challege Thought Process

Since this is challenge had an aggressive time limit:

1. I didn't take the time to handle aggressive optional if-lett'ing.  I force unwrapped a lot of the traditional `Foundation` apis that existed before Swift did (ex: `URLSession` and `IBOutlets`), and guarantees such as the API that was used to build a `URL`.
2. I didn't take the time to create models that would be representative of a production system.
3. I did all logic in the `ViewController` for convenience.  This allowed for quick usage/lookup/reference.  Ultimately, the `ViewController` was ~100 lines so this is ok.
4. I manually deserialized the response JSON
5. I didn't care about error handling with the API request/response.

## Challenge Execution

I was able to complete everything except the dynamic text within the time limit.  I was currently in the process of remembering the technique for basic dynamic `UITableViewCell.textLabel?.text` when I ran out of time.

When I was instructed to stop for questions, I commented that normally dynamic sizing can be achieved with custom `UITableViewCell` subclasses by making sure that all the labels follow proper constraint "maths." I also communicated that I would probably look for the easiest solution by taking a look at the `UITableViewCell.textLabel?.numberOfLines` and set it to `0`.  After the challenge was over, I went and tried that approach, and it indeed made the cells self sized.

## Hindsight Execution

TBD

The completed code can be found in the [Hindsight](Hindsight/) directory of this repo.

## Final Thoughts

TBD

[^1]: The exercise itself was 30 minutes.  However, this challenge was a surprise and wasn't communicated to me beforehand and my workstation wasn't setup.  I spent about ~5 minutes getting Xcode ready for development.