import Vapor

func routes(_ app: Application) throws {
	app.get { req -> String in
		return "Hello world"
	}
}
