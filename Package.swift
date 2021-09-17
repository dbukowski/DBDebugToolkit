// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "DBDebugToolkit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DBDebugToolkit",
            targets: ["DBDebugToolkit"]
        ),
    ],
    targets: [
        .target(
            name: "DBDebugToolkit",
            path: "DBDebugToolkit",
            resources: [.process("Resources")],
            publicHeadersPath: "include"
        ),
    ]
)
