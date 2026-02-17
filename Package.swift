// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ElectricBillPro",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "ElectricBillPro",
            targets: ["ElectricBillPro"]),
    ],
    targets: [
        .target(
            name: "ElectricBillPro",
            path: "Sources"),
    ]
)
