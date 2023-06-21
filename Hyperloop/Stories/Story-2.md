# 2. Allow user to search for images

## Description

As a user, after I launch the app, I'm able to search for any image using a search bar.

## Additional Notes

1. The Chihuahua images will still be the default list when a user launches the app.  It's not until the user enters an image in the search bar that the list view is updated with the new results.
2. The search bar will only execute the search once the "done" button is tapped.
3. A spinner is displayed while the user is waiting for their search results.

## Point Value: 1

## Acceptance Criteria

1. A `UISearchBar` is use to query the Imgur API for new images
2. The `UITableView` is temporarily removed/hidden from the view and is replaced with an animated `UIActivityIndicatorView` until the search results are shown to the user in an updated `UITableView`
3. If a search does not return any results, show the message "Unable to find image".

## Dependencies

Story-1

## Comments

1. Due to some `Debouncer` code that I have in an open source project, I went ahead and wired it up to the search controller directly.
2. The default debouncer time I used since it wasn't specified is `0.3` seconds.
3. Since the searching is based on user input, a done button wasn't created.
4. No spinner is needed because I default to showing "Chihuahua" images by default.
5. Errors were provided for "API" errors, and if search results don't return anything.
6. The hiding of the `UITableView` is only done when there is an error.
7. Added search term to "Unable to find image" text.

### Status

Completed