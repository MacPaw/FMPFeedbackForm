// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FMPFeedbackForm",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_10)
    ],
    products: [
    .library(
            name: "FMPFeedbackForm",
            targets: ["FMPFeedbackForm"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FMPFeedbackForm",
            path: "FMPFeedbackForm",
            exclude: ["Info.plist"],
            resources: [.process("Resources")]
        )
    ]
)
