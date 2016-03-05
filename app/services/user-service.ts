/**
 * Word service
 * *Author*: Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)
 * *Version:* 1.0.0
 */





// External
// ------------------------------
import {Injectable} from "angular2/core";
import {Http, URLSearchParams, Jsonp} from "angular2/http";
import {Location} from "angular2/router";
import Rx = require("rxjs")
import io = require("socket.io-client")



// Imports
// ------------------------------
import {settings} from "../settings"





// Channel service
// ------------------------------
@Injectable()
export class WordStreamService {





	// constructor
	// ------------------------------

	// vars
	private streamId: string;
	private wordStream: Rx.Observable<any[]>;

	// constructor
	constructor(
		private http: Http,
		private location: Location) {
	}





	// Channel service api
	// ------------------------------

	// create subject
	public wordStreamForId(streamId: string): Rx.Observable<any[]> {

		return this.loadWordsFromServer(streamId).map(initalWordlist => { return { type:"WORD_INIT", data: initalWordlist } })
		.merge(this.socketWordStreamFor(streamId))
		.reduce((currentList: TVWord[], wordEvent: TVWordEvent) => {
			switch (wordEvent.type) {
				case "WORD_INIT": {
					currentList = _.chain(currentList)
						.union(wordEvent.data)
						.orderBy("startTimeRelative")
						.value()
					break;
				}
				case "WORD_ADD": {
					let index = _.chain(currentList).findIndex((e:TVWord) => e.startTimeRelative > wordEvent.data).subtract(1).clamp(0, currentList.length-1).value()
					currentList.splice(index, 0, wordEvent.data)
					break;
				}
				case "WORD_UPDATE": {
					let index = _.findIndex(currentList, {id: wordEvent.data.id})
					currentList.splice(index, 1, wordEvent.data)
					break;
				}
				case "WORD_DELETE": {
					let index = _.findIndex(currentList, {id: wordEvent.data.id})
					currentList.splice(index, 1)
					break;
				}
			}
			return currentList
		}, [])
		// this.socketWordStreamFor(streamId).
		// this.streamId = streamId
		// this.wordStream = this.loadWordsFromServer(streamId)

		// 	.retry(3)
		// 	.startWith([])
		// return this.wordStream
	}


	// TODO: wrap json parse
	private socketWordStreamFor(streamId: string): Rx.Observable<TVWordEvent> {
		Rx.Observable.create()
		return Rx.Observable.create((observable) => {
			var io_fix: any = io
			var socket: SocketIOClient.Socket = new io_fix(settings.serverSocketEndpoint)
			socket.on("connect", () => {
				socket.emit("message", JSON.stringify({ type: "STREAM_SUBSCRIBE", data: streamId }));
			})
			socket.on("message", (messageString) => {
				try {
					let message = JSON.parse(messageString)
					observable.next(message)
				}
				catch (err){
					console.error(err)
					observable.error(err)
				}

			})
			return () => {
				socket.emit("message", JSON.stringify({ type: "STREAM_UNSUBSCRIBE", data: streamId }));
				socket.disconnect()
			}
		})
	}





	// utils
	// ------------------------------

	// load stream
	private loadWordsFromServer(streamId: string): Rx.Observable<Array<any>> {
		console.log(`Getting from: ${settings.serverEndpoint}/api/v1/word-streams/${streamId}`)
		return this.http
			.get(`${settings.serverEndpoint}/api/v1/word-stream/${streamId}`)
			.map(res => res.json())
	}
}

export interface TVWordEvent {
	type: "WORD_ADD" | "WORD_UPDATE" | "WORD_DELETE";
	data: any;
}

export interface TVWord {
	id: string;
	streamId: string;
	groupId: string;
	version: number;
	difficulty: number;
	category: string;
	word: string;
	descriptionHtml: string;
	imageUrl: string;
	mediaUrl: string;
	translation: { [langCode: string]: TVWordTranslation[] }
	startTimeEpoch: number;
	startTimeRelative: number;
}

interface TVWordTranslation {
	word: string;
	phonetic: string;
	origin: string;
	descriptionHtml: string;
}
