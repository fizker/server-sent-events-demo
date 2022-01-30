public struct MessageEvent: Codable {
	public var data: String
	public var eventType: String?
	public var lastEventID: String?
	public var id: String?
}

public extension MessageEvent {
	init?(lines: [MessageLine], lastEventID: String?) {
		var data: [String] = []
		for line in lines {
			switch line {
			case let .event(value):
				eventType = value
			case let .data(value):
				data.append(value)
			case let .id(value):
				id = value
			case .comment(_), .unknown(_, _), .retry(_):
				break
			}
		}

		self.data = data.joined(separator: "\n")
		self.lastEventID = id ?? lastEventID
	}

	var asLines: [MessageLine] {
		var lines: [MessageLine] = []

		lines.append(contentsOf: data.components(separatedBy: .newlines).map { .data($0) })
		if let id = id {
			lines.append(.id(id))
		}
		if let eventType = eventType {
			lines.append(.event(eventType))
		}

		return lines
	}
}
