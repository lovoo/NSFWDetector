// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "NSFWDetector",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "NSFWDetector",
            targets: ["NSFWDetector"]
        )
    ],
    targets: [
        .target(
            name: "NSFWDetector",
            path: "NSFWDetector"
        )
    ]
)
