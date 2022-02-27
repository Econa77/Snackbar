// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Snackbar",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Snackbar",
            targets: ["Snackbar"]),
    ],
    targets: [
        .target(
            name: "Snackbar"),
        .testTarget(
            name: "SnackbarTests",
            dependencies: ["Snackbar"]),
    ]
)
