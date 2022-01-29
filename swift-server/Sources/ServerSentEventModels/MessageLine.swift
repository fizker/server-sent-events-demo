public enum MessageLine: Codable {
	case event(String)
	case data(String)
	case id(String)
	case retry(Int)
	case comment(String)
	case unknown(String, String)
}
