// swift-tools-version: 6.3
import PackageDescription
let package = Package(name: "TokenEntry", platforms: [.iOS(.v18), .macOS(.v15)],
    products: [.library(name: "TokenEntry", targets: ["TokenEntry"])],
    targets: [.target(name: "TokenEntry"), .testTarget(name: "TokenEntryTests", dependencies: ["TokenEntry"])],
    swiftLanguageModes: [.v6])
