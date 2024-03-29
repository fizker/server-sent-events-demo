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
		.package(url: "https://github.com/fizker/swift-server-sent-event-models.git", from: "0.0.1"),
	],
	targets: [
		.target(
			name: "ServerSentEventVapor",
			dependencies: [
				.product(name: "Vapor", package: "vapor"),
				.product(name: "ServerSentEventModels", package: "swift-server-sent-event-models"),
			]
		),
		.executableTarget(
			name: "EventSourceServer",
			dependencies: [
				.product(name: "Vapor", package: "vapor"),
				.product(name: "ServerSentEventModels", package: "swift-server-sent-event-models"),
				"ServerSentEventVapor",
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
