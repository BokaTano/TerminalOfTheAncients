## Excercises:
1. Build and start the game (WelcomeRitual)
1. Run a shell script that makes it easier to start the build and then start the game (ShellScriptRitual)
1. Decode data from a local swift data store, count something and write it into a file for the game (GlyphMatrixPuzzle)
1. Download Data from a locally running server (BeaconPuzzle)
1. Connect it to a MCP **or**
1. Create own CLI to let it talk to

## Ablauf

### 1. CLI and why should care
* Slides

### 2. Basic CLI usage and Arguments
* Slides

### 3. Installation and Setup
* Stick and Download
* Setup Guide on Slides
    * Download (Swift 6.2 Toolchain)[https://download.swift.org/swift-6.2-branch/xcode/swift-6.2-DEVELOPMENT-SNAPSHOT-2025-08-01-a/swift-6.2-DEVELOPMENT-SNAPSHOT-2025-08-01-a-osx.pkg] or through this
    * swiftly is new

    ```bash
    swiftly install 6.2-snapshot
    swiftly use 6.2-snapshot
    swift --version
    swift package clean
    swift build
    swift run TOTA --status
    ```
    * once you installed the 6.2 they should do something, close the laptop ie.

### 4. Welcome Ritual Puzzle
* Run the project
* Solve that you have to start it with the --initiate flag

### 5. Shell Script Ritual
* Slides to explain the situations of having scripts from other colleages or the internet
* Show how to incorporate Subprocess package
* Show how to use Subprocess
* Mark the sections for the puzzle for easy entrance
* Install the CLI globally

### 6. Glyph Matrix Puzzle
* Now we are in Swift World and we can not only bridge to the terminal world but use our existing swift knowledge. Lets try this with Swift Data
* Lets write our first own Script
* Explain the structure
* Mark the start 
* Explain the fetching of the swift data database
* let them run and build the `render_glyphs.swift` 
* let them try to print something
* let them test if their print is correct inside TOTA

### 7. Beacon Puzzle
* I don't know about you, but what I often do and see doing is working with APIs in scripts. You download masses of data, pipe them into a processor, and extract data from it. At my work we often do it in typescript. But typescript is not reaaally typesafe, does not really work nicely with asynchronicity. So let's try it with Swift and use our new 6.2 Tooling as well
* To fully leverage it, I want to use streaming. Our lighthouse is sending us data. But not just thousands of pages of data in one request or nicely paginated. No! It streams us data chunks and we will never know when it is finished. 
    * show the `main.swift` inside the lighthouse
          ```headers.replaceOrAdd(name: .contentType, value: "text/event-stream")```
    * show the ``` try await URLSession.shared.bytes(for: streamRequest)``` bytes method in slide, it's the magic methods that receives the stream data
        * The .lines property on AsyncBytes was introduced in Swift 6.2. In Swift 6.1, you'd need to manually iterate over bytes and split by newlines
    * @Sendable
        * This explicit @Sendable annotation on closures is a Swift 6.2+ feature. In earlier versions, you'd need to use @Sendable on the function itself or rely on implicit sendability
        * @Sendable = "Safe to Send" (across threads)
        * The "Thread Safety Contract"
        
* can I also download the docC with the project?
Simple Explanation:
Think of @Sendable as a promise that says "this code is safe to use across different threads."
Real-world analogy:
Imagine you have a toy that multiple kids want to play with
@Sendable is like putting a label on the toy that says "This toy is safe for all kids to share"
Without this label, Swift won't let you pass the toy between kids (threads) because it might break
This says: "I promise this closure is safe to run on any thread, so you can use it in async contexts."
        * The @unchecked Sendable Reality:
What it means:
@unchecked Sendable = "We promise this is thread-safe, but Swift can't verify it automatically"
It's like saying "Trust us, this is safe" without Swift's compiler checking
        * Explanation of the AsyncStream 
* Optional Task is Timeout functionality
* Check if processing has worked

### 8. Finish?

### Optional
* If you make your own CLI and make it to something, you get something (ask Tim)


