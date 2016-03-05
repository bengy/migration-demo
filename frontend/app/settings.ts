export module settings {
	// export var serverUrl = `http://herokuURL`
	export var serverUrl = `http://localhost`
	export var serverEndpoint: string = `${settings.serverUrl}:3000`
	export var serverSocketEndpoint: string = `${settings.serverUrl}:8940`
}