# Server-Sent Events demo

Demo servers and clients for testing Server-Sent Events (EventSource in the browser)


## Bundled servers

The solution bundles some servers in different languages.
They all bundle the same web client for easy testing, or any other client can be pointed at them.


### Running all servers in docker

The simplest way to run the servers is to use docker.

In the root, run `docker compose up -d` to start all servers.

The following ports are used by default:

- 8030: NodeJS server
- 8031: Swift server


### Node.js

1. `cd nodejs-server`
2. `npm install`
3. `npm start`

The default port is 8030. To change the port of the server, simply set the `PORT` env var before starting the server: `PORT=1234 npm start`


### Swift

1. `cd swift-server`
2. `swift build`
3. `swift run`

The default port is 8031. To change the port of the server, simply set the `PORT` env var before starting the server: `PORT=1234 swift run`


## Bundled clients

- Web: The web-client can be accessed on the root path of the servers.
- CURL: `curl <server-address>/messages`. This is done by the `curl-client` script, which is a simple bash script.
- .NET CLI: Open the `net-cli/net-cli.sln` file in any .NET-capable IDE and run the app.
