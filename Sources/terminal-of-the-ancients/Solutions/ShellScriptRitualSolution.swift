// 1. add the Subprocess package to package.swift
/*
...
dependencies: [
...
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.3.0"),
    ],
    targets: [
        .executableTarget(
        ...
            dependencies: [
                ...
                .product(name: "ShellOut", package: "ShellOut"),
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
    try shellOut(to: "./build_and_run.sh")
*/

// 4. add the global CLI installation in another terminal
/*
swift build -c release
sudo cp .build/release/TOTA /usr/local/bin/tota
*/

// 5. run tota again and get a success
