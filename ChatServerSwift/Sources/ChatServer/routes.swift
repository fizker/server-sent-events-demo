import Fluent
import Vapor
import ServerSentEventModels
import ServerSentEventVapor

extension UserModel: Authenticatable {
}

struct UserAuthenticator: AsyncBasicAuthenticator {
	func authenticate(basic: BasicAuthorization, for request: Request) async throws {
		guard
			let user = try await UserModel.query(on: request.db)
			.filter(\.$username == basic.username)
			.first(),
			try await request.password.async.verify(basic.password, created: user.passwordHash)
		else { return }

		request.auth.login(user)
	}
}

func routes(_ app: Application) throws {
	let eventController = ServerSentEventController()
	let userController = UserController()

	let app = app.grouped(UserAuthenticator())

	app.get { req -> Response in
		req.fileio.streamFile(at: "../client/index.html")
	}

	app.get("messages") { req -> ServerSentEventResponse in
		let id = UUID()
		print("Adding SSE client (\(id))")
		return eventController.createResponse(id: id, onClose: {
			print("Removing SSE client (\(id))")
			eventController.close(id: id)
		})
	}

	app.post("messages") { req -> String in
		let message = try req.content.decode(MessageEvent.self)
		eventController.emit(message)

		return "Message is \(message)"
	}

	app.group("users") { app in
		app.grouped(UserModel.guardMiddleware()).get("self") { req in
			try Content(req.auth.require(UserModel.self).asDTO)
		}

		app.post("register") { try await Content(userController.registerUser(req: $0)) }
	}
}

struct Content<T: Codable>: Codable, Vapor.Content {
	var item: T

	init(_ item: T) {
		self.item = item
	}

	init(from decoder: Decoder) throws {
		item = try T(from: decoder)
	}

	func encode(to encoder: Encoder) throws {
		try item.encode(to: encoder)
	}
}
