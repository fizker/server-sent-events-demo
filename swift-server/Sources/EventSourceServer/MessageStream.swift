import Foundation
import ServerSentEventModels

class MessageStream {
	typealias Stream = AsyncStream<MessageEvent>

	private var streams: [UUID: Stream.Continuation] = [:]

	init() {
	}

	func createStream(id: UUID) -> Stream {
		return AsyncStream {
			streams[id] = $0
		}
	}

	func emit(_ message: MessageEvent) {
		for (_, continuation) in streams {
			continuation.yield(message)
		}
	}

	func close() {
		for (_, continuation) in streams {
			continuation.finish()
		}
		streams = [:]
	}

	func close(id: UUID) {
		let continuation = streams.removeValue(forKey: id)
		continuation?.finish()
	}
}
