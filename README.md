# OnTheMap
Built an app that posts user-generated location information to a shared map, pulling the locations of fellow Nanodegree students, with custom messages about themselves or their learning experience.

## Technologies Used
Swift, UIKit, NSURLSessionsJSON, ParsingMKMapViews.

## Install
```
git clone git@github.com:manujua82/MemeMe.git
```

## Usage 
The On The Map app allows users to share their location and a URL with their fellow students. To visualize this data, On The Map uses a map with pins for location and pin annotations for student names and URLs, allowing students to place themselves “on the map,” so to speak.

First, the user logs in to the app using their Udacity username and password. After login, the app downloads locations and links previously posted by other students. These links can point to any URL that a student chooses. We encourage students to share something about their work or interests.

After viewing the information posted by other students, a user can post their own location and link. The locations are specified with a string and forward geocoded. They can be as specific as a full street address or as generic as “Costa Rica” or “Seattle, WA.”
The app has three view controller scenes:

- Login View: Allows the user to log in using their Udacity credentials, or (as an extra credit exercise) using their Facebook account.
- Map and Table Tabbed View: Allows users to see the locations of other students in two formats.  
- Information Posting View: Allows the users specify their own locations and links.


## Screenshot 
![Alt text](/ScreenShot/screenshot.jpg?raw=true "") 

## License
The contents of this repository are covered under the [MIT License](LICENSE).
