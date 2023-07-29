# Live Camera SwiftUI

Code from the [video](https://www.youtube.com/watch?v=cLnw5z8ZGqM&t=22s) which shows how to read frames from a phone's camera and display the feed on the screen using SwiftUI, without UIKit.

## Updates

29/07/2023

- Changed default value for `permissionGranted` in `FrameHandler` to `true` to prevent a bug when the user runs the app the first time
- Added `self` to some method calls and variables in `FrameHandler` to make code consistent
