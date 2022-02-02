import Vapor
import ServerSentEventModels
import ServerSentEventVapor

func routes(_ app: Application) throws {
	let stream = MessageStream()

	app.get { req -> Response in
		req.fileio.streamFile(at: "../client/index.html")
	}

	app.get("messages") { req -> ServerSentEventResponse in
		let id = UUID()
		print("Adding SSE client (\(id))")
		return ServerSentEventResponse(stream: stream.createStream(id: id), onClose: {
			print("Removing SSE client (\(id))")
			stream.close(id: id)
		})
	}

	app.post("messages") { req -> String in
		let message = try req.content.decode(MessageEvent.self)
		stream.emit(message)

		return "Message is \(message)"
	}
}
