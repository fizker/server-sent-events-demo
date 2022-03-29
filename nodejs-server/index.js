import express from "express"
import path from "path"
import SSEStream from "ssestream"
import { pipeline } from "stream"
import { v4 as uuid } from "uuid"

const __dirname = path.dirname(import.meta.url).replace(/^file:\/\//, "")
const app = express()
const port = process.env.PORT ?? 8030

const sseClients = new Map()

app.get("/", (req, res) => {
	res.sendFile(path.join(__dirname, "../client/index.html"))
})

app.get("/messages", (req, res) => {
	const id = uuid()
	const stream = new SSEStream(req)

	sseClients.set(id, stream)
	console.log(`Adding SSE client (${id})`)

	pipeline(stream, res, (err) => {
		if(err) {
			console.error(err.message)
		}
		sseClients.delete(id)
		console.log(`Removing SSE client (${id})`)
	})
})

app.post("/messages", express.json(), express.urlencoded({ extended: true }), (req, res) => {
	const message = req.body

	if(message.data == null) {
		res.status(400).send("Message must have `data` attribute")
		return
	}

	if(message.type != null && typeof message.type !== "string") {
		message.type = null
	}

	if(message.id != null && typeof message.id !== "string") {
		message.id = null
	}

	console.log({ message })
	res.send(`Message is ${JSON.stringify(message)}`)

	for(const client of sseClients.values()) {
		client.write({
			id: message.id,
			event: message.type,
			data: message.data,
		})
	}
})

app.listen(port, () => {
	console.log(`Server running on port ${port}`)
})
