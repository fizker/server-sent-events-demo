# Server-Sent Events demo

Demo server and clients for testing Server-Sent Events (EventSource in the browser)

## Running the server

1. `npm install`
2. `npm start`

To change the port of the server, simply set the `PORT` env var before starting the server: `PORT=1234 npm start`

## Bundled clients

- Web: The web-client can be accessed on the root path of the server.
- CURL: `curl <server-address>/messages`. This is done by the `curl-client` script, which is a simple bash script.
- .NET CLI: Open the net-cli/net-cli.sln file in any .NET-capable IDE and run the app.
