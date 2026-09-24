// swift-tools-version: 5.9

import PackageDescription

let controlUnit = Context.environment["PARAKEY_USE_CONTROL_UNIT"] == "true"
let sdk = controlUnit ? "parakey-cu-sdk-ios" : "parakey-sdk-ios"

let package = Package(
    name: "parakey_sdk_flutter",
    platforms: [
        .iOS("15.1"),
    ],
    products: [
        .library(name: "parakey-sdk-flutter", targets: ["parakey_sdk_flutter"]),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/parakey-ab/\(sdk).git", exact: "2.7.1"),
    ],
    targets: [
        .target(
            name: "parakey_sdk_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "ParakeySDK", package: sdk),
            ]
        ),
    ]
)
