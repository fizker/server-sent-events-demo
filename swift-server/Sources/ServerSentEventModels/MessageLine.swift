import Foundation

public enum MessageLine: Codable {
	case event(String)
	case data(String)
	case id(String)
	case retry(Int)
	case comment(String)
	case unknown(String, String)
}

public extension MessageLine {
	init?(string: String) {
		let key: String
		let value: String
		if let colon = string.firstIndex(of: ":") {
			key = String(string[..<colon])
			value = String(string[colon...]).trimmingCharacters(in: .whitespaces)
		} else {
			key = string
			value = ""
		}

		switch key {
		case "":
			self = .comment(value)
		case "event":
			self = .event(value)
		case "id":
			self = .id(value)
		case "data":
			self = .data(value)
		case "retry":
			guard let val = Int(value)
			else { fallthrough }
			self = .retry(val)
		default:
			self = .unknown(key, value)
		}
	}

	var asString: String {
		switch self {
		case let .event(value):
			return "event: \(value)"
		case let .data(value):
			return "data: \(value)"
		case let .id(value):
			return "id: \(value)"
		case let .retry(value):
			return "retry: \(value)"
		case let .comment(value):
			return ": \(value)"
		case let .unknown(key, value):
			return "\(key): \(value)"
		}
	}
}
