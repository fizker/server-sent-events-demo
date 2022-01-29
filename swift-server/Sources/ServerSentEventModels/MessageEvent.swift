public struct MessageEvent: Codable {
	public var data: String
	public var eventType: String?
	public var lastEventID: String?
	public var id: String?
}
