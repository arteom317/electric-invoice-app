// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ElectricBillPro",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ElectricBillPro",
            targets: ["ElectricBillPro"])
    ],
    targets: [
        .target(
            name: "ElectricBillPro",
            dependencies: [],
            path: "Sources"
        )
    ]
)
