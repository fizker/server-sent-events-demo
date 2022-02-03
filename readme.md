# Server-Sent Events demo

Demo servers and clients for testing Server-Sent Events (EventSource in the browser)

## Bundled servers

The solution bundles some servers in different languages.


### Node

1. `npm install`
2. `npm start`

To change the port of the server, simply set the `PORT` env var before starting the server: `PORT=1234 npm start`


### Swift

1. `cd swift-server`
2. `swift build`
3. `swift run`

To change the port of the server, simply set the `PORT` env var before starting the server: `PORT=1234 swift run`


## Bundled clients

- Web: The web-client can be accessed on the root path of the servers.
- CURL: `curl <server-address>/messages`. This is done by the `curl-client` script, which is a simple bash script.
- .NET CLI: Open the `net-cli/net-cli.sln` file in any .NET-capable IDE and run the app.
