import Vapor

var env = try Environment.detect()
if env.arguments.count == 1 {
	env.arguments.append("serve")
}
if env.arguments[1] == "serve" && !env.arguments.contains("--port") {
	env.arguments.append("--port")
	env.arguments.append("8031")
}
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
