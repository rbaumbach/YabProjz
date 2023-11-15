# TrackVia iOS Code Challenge

## Objective:
The goal of this project is to create an iOS application that fetches and displays images from a remote source in a grid view, with the functionality to fetch more images as the user scrolls.

## Specifications:
### Language & Framework:
The project should be implemented using Swift and you may use either UIKit or SwiftUI, depending on your preference.

### Project Architecture:
The architecture of the project is completely up to you, though we have provided a very basic scaffold to get started. 
 
### Code Quality:
Code should be clean, self-documenting and organized in a logical manner. Adherence to Swift best practices is expected. Please indicate any future or advanced considerations with TODO comments.

### Data API:
Use an image API such as the [Unsplash Image API](https://unsplash.com/developers) or [Flickr API](https://www.flickr.com/services/api/) to fetch images. You will need to fetch a list of images and their metadata. Please adhere to the API guidelines of the service you choose to utilize.

### Grid View:
Display the fetched images in a grid view. Each image should be displayed with at least one piece of metadata (such as the title or author's name).

### Pagination:
As the user scrolls through the grid view, the app should fetch more images and add them to the grid. Implement this functionality in a way that minimizes wait time for the user. Thought should be given to data usage.

### Image Detail View:
When an image in the grid is tapped, navigate to a detail view that displays the image in larger size, along with more metadata about the image.

### Error Handling:
The app should appropriately handle any errors that might occur during the data fetching process.

### UI/UX:
While this is primarily a technical challenge, please ensure the app has a clean and intuitive interface. Extra credit for thoughtful UI and UX touches like transitions and animations.

## Deliverables:
1. The complete Xcode project, zipped and delivered to your point contact for TrackVia.
2. README file detailing:
    - How to run the project
    - Any assumptions made or trade-offs in your solution
    - Explanation of the approach used for pagination
    - Any other pertinent information

## Grading:
 - The challenge must be submitted within 7-days. Take as long as you want. 
 - You will NOT be graded on how quickly you return the challenge
 - Emphasis on:
    - the quality of your code (more is not always better!)
    - your decision-making process
    - thoughtfullness for current and future optimizations (feel free to use TODOs)
    - your ability to create a clean, user-friendly interface and experience 
