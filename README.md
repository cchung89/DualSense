# CSC 436 Final Project: Dual Sense
## Interactive Sound and Color Vision Testing

### External iOS APIs and Technologies
* AVFoundation
* Firebase
* [iOS Charts](https://github.com/danielgindi/Charts)

### Current App Overview
* Basic Sound and Color Vision Testings are working successfully
* Ishihara Color Plate Test is working successfully
* The Pattern (Color Vision + Hearing) Test is working successfully
* Total of 4 tests currently
* Tutorials/Information for sound and color vision
* Store the sound, color vision, pattern matching data into the Firebase
* Graph the data as a bar graphs using iOS Charts (Percentage of Success for each sound and color; success and total patterns for pattern test)
* List the data into a table as well
* Allow the user to view other users' data results as well
* User login by typing in their names
* Options to choose which tests or tutorials to go into

### Login
* Has error notification for invalid name

### Sound Tutorial
* Frequency Range: About 6 - 28200 Hz
* Intensity Range: 0 - 1 tone volume
* URL to a website with information regarding Audiogram

### Color Tutorial
* List of Colorblind types: Normal, Protanomaly, Protanopia, Deuteranomaly, Deuteranopia, Tritanomaly, Tritanopia, Achromatomaly, Achromatopsia
* Use RGBA hex codes for the color (ex: ff0000ff, which is color red)
* Show both normal vision and colorblind vision color
* Hex codes check with error notification
* Show URLs for information regarding colorblindness and photo simulation

### Sound Test
* For sound frequencies: 250, 500, 1000, 2000, 4000, 8000 Hz (General range of Audiometry hearing test)
* Might include more sound frequencies in the future
* Might use different intensity in the future also

### Color Vision Test
* For color: red, yellow, blue, orange, green, purple (Primary and Secondary colors)
* Might include more color in the future

### Pattern Matching Test (Hearing + Color)
* Used sound frequencies: 440, 460, 480, 500, 520, 540 Hz
* For color: red, yellow, blue, orange, green, purple
* Might include more sound and color in the future

### Ishihara Color Plate Test
* Mainly for Red-Green and Total Colorblindness
* Might include more plate tests in the future

### In Progress
* More sound and color tests
* Add some extra authentication login for user with Firebase

### Data Structure for Sound and Color Storage
```
SoundData / ColorData {  
    name: String
    color / sound 1 {
        success: Int
        total: Int
    }
    color / sound 2 {
        success: Int
        total: Int
    }
    color / sound 3 {
        success: Int
        total: Int
    }
    .
    .
    .
}
```

### Data Structure for Pattern Storage
```
PatternData {
    name: String
    success: Int
    total: Int
}
```

### Current App Issues to be Noted
* Rare case of app freezes
* Minor constraint issues

### Hearing Test Instruction
* Click the `Start` button to start the countdown
* A tone will be played for 1-3 seconds after countdown reaches zero
* The `Yes` and `No` buttons appear once the sound finished playing
* Click either one depending on whether you hear the sound or not
* User response is recorded for whether the user hears the sound or not, and the `Yes` and `No` buttons will vanish
* The next tone is played and the process repeats until you exit or click `Stop` button
* Can either click `Start` to test again or get the data result with the `Get Result` button
* The data will be recorded to the Firebase and also graph on a chart once `Get Result` button is clicked

### Color Vision Test Instruction
* Click the `Start` button to start the countdown
* `Start` button will switch to `Stop` button for user to stop the test
* A color block will apear once the countdown reaches zero
* Click the color button that matches the correct color of the center block
* User response is recorded for whether the user gets the right match
* The next color block will take place and the test process repeat until the user click `Stop` or `Get Result` buttons
* The data will be recorded to the Firebase and also graph on a chart once `Get Result` button is clicked
* Click the `Stop` button to stop the test

### Pattern Test Instruction
* First each tones are played with a designated color before the test can start
* Click `Start` button to start the countdown
* A tone is played once the countdown is done
* Match the tone with the right color
* User response is recorded for whether the user gets the right match
* The next tone is played and the process repeats until you exit or click `Stop` button
* Can either click `Start` to test again or get the data result with the `Get Result` button
* Can also click `Reset` to get a new pattern for the test
* The data will be recorded to the Firebase and also graph on a chart once `Get Result` button is clicked

### Ishihara Plate Test Instruction
* For each plate, click on one of the four buttons
* If it is correct, the app will state correct and normal
* If it is wrong, it shows wrong and what colorblind condition is it related to if applicable
* Click `Next` button to get a different color plate

