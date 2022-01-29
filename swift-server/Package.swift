// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "EventSourceServer",
	platforms: [
		.macOS(.v12),
	],
	products: [
		.executable(
			name: "EventSourceServer",
			targets: [
				"EventSourceServer",
			]
		),
	],
	dependencies: [
		.package(url: "https://github.com/vapor/vapor.git", from: "4.55.0"),
	],
	targets: [
		.target(name: "ServerSentEventModels"),
		.executableTarget(
			name: "EventSourceServer",
			dependencies: [
				.product(name: "Vapor", package: "vapor"),
				"ServerSentEventModels",
			],
			swiftSettings: [
				// Enable better optimizations when building in Release configuration. Despite the use of
				// the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
				// builds. See <https://github.com/swift-server/guides#building-for-production> for details.
				.unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
			]
		),
	]
)
