import ServerSentEventModels

class MessageStream {
	private(set) var stream: AsyncStream<MessageEvent>!
	private var continuation: AsyncStream<MessageEvent>.Continuation?

	init() {
		stream = AsyncStream {
			self.continuation = $0
		}
	}

	func emit(_ message: MessageEvent) {
		continuation?.yield(message)
	}

	func close() {
		continuation?.finish()
		continuation = nil
	}
}
