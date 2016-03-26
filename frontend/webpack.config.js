var path = require('path');

module.exports = {
	context: path.join(__dirname, "app"),
	entry: [
		path.normalize('es6-shim/es6-shim.min'),
		'reflect-metadata',
		path.normalize('zone.js/dist/zone-microtask'),
		path.resolve('app/app')
	],
	output: {
		path: path.resolve('www/build/js'),
		filename: 'app.bundle.js',
		pathinfo: false // show module paths in the bundle, handy for debugging
	},
	module: {
		loaders: [
			{
				test: /\.ts$/,
				loader: 'awesome-typescript',
				query: {
					'doTypeCheck': true
				},
				include: path.resolve('app'),
				exclude: /node_modules/
			},
			{
				test: /\.js$/,
				include: path.resolve('node_modules/angular2'),
				loader: 'strip-sourcemap'
			}
		],
		noParse: [
			/es6-shim/,
			/reflect-metadata/,
			/zone\.js(\/|\\)dist(\/|\\)zone-microtask/
		]
	},
	resolve: {
		root: [
			'app'
		],
		alias: {
			'app': path.resolve('app'),
			'ionic-framework': path.resolve('node_modules/ionic-framework'),
			'ionic-native': path.resolve('node_modules/ionic-native'),
			'angular2': path.resolve('node_modules/angular2'),
			'socket.io': path.resolve('node_modules/socket.io-client'),
			'moment': path.resolve('node_modules/moment'),
			'facedetection': path.resolve('node_modules/jquery.facedetection')
		},
		extensions: ["", ".js", ".ts"]
	}
};
