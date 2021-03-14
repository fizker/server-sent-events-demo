import express from "express"

const app = express()
const port = process.env.PORT ?? 8030

app.get("/", (req, res) => {
	res.send("hello world")
})

app.post("/messages", express.json(), (req, res) => {
	const message = req.body

	if(message.name == null || typeof message.name !== "string") {
		// Error out
		res.status(400).send("Message must have `name` attribute")
		return
	}

	console.log({ message })
	res.send(`Message is ${JSON.stringify(message)}`)
})

app.listen(port, () => {
	console.log(`Server running on port ${port}`)
})
