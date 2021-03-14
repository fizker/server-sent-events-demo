import express from "express"
import path from "path"

const __dirname = path.dirname(import.meta.url).replace(/^file:\/\//, "")
const app = express()
const port = process.env.PORT ?? 8030

app.get("/", (req, res) => {
	res.sendFile(path.join(__dirname, "client/index.html"))
})

app.post("/messages", express.json(), express.urlencoded({ extended: true }), (req, res) => {
	const message = req.body

	if(message.name == null || typeof message.name !== "string") {
		// Error out
		res.status(400).send("Message must have `name` attribute")
		return
	}

	if(message.data === "") {
		message.data = null
	}

	console.log({ message })
	res.send(`Message is ${JSON.stringify(message)}`)
})

app.listen(port, () => {
	console.log(`Server running on port ${port}`)
})
