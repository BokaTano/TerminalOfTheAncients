// 1. add the Subprocess package to package.swift
/*
...
dependencies: [
...
    .package(url: "https://github.com/swiftlang/swift-subprocess.git", branch: "main"),
    ],
    targets: [
        .executableTarget(
        ...
            dependencies: [
                ...
                .product(name: "Subprocess", package: "swift-subprocess"),
            ],
        )
    ]
*/

// 2. call the script from the terminal
/*
    ./build_and_run.sh
*/

// 3. add the script to the validate method and get an error on building tota
/*
    ...
    let result = try await run(.path("./build_and_run.sh"), output: .string(limit: 1024 * 1024))
*/

// 4. add the global CLI installation in another terminal
/*
swift build -c release
sudo cp .build/release/TOTA /usr/local/bin/tota
*/

// 5. run tota again and get a success
