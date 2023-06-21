# 1. Display Chihuahua images to a user

## Description

As a user, when I launch the app, I'm able to see 10 Chihuahua images in a list view with a description from Imgur.

## Additional Notes

1. The images can be arranged in any order.

## Point value: 1

## Acceptance Criteria

1. After app launch the main view displays a `UITableView` that fetches the first 10 Chihuahua images from Imgur.
2. The images are displayed in the same order that is returned from the Imgur api.
3. The `UITableViewCell` displays the Chihuahua image on the left, with the description of the image on the right.
4. Placement of the image and text will follow default IOS margins and placement.

## Comments

1. Since the "gallery" api is given for this exercise, I will make the assumption that I will take all the images from each gallery returned from the API and "flatten" them out into a single datasource that will be displayed to the user.

Ex: [Gallery.images] (array of arrays) -> [Image]

2. The height of each `UITableView` row was set to a static `132.0 pt.` since the requirements didn't state one. This is 3x the size of the normal `44.0 pt.` height.

3. Descriptions returned from the Imgur API for images can be nil. I put "N/A" for the description those items.  In a future ticket I will update this to the name of the search term that was used.

### Status

Completed