import Vapor
import ServerSentEventModels

func routes(_ app: Application) throws {
	let stream = MessageStream()

	app.get { req -> Response in
		req.fileio.streamFile(at: "../client/index.html")
	}

	app.get("messages") { req -> ServerSentEventResponse in
		return ServerSentEventResponse(stream: stream.stream)
	}

	app.post("messages") { req -> String in
		let message = try req.content.decode(MessageEvent.self)
		stream.emit(message)

		return "Message is \(message)"
	}
}
