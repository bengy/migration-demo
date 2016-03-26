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
import {Observable} from "rxjs";
import io = require("socket.io-client")



// Imports
// ------------------------------
import {settings} from "../settings"





// Channel service
// ------------------------------
@Injectable()
export class EventService {





	// constructor
	// ------------------------------
	public eventStream: Observable<IEvent[]>;
	private refreshStream: Observable<any>;

	// constructor
	constructor(
		private http: Http,
		private location: Location) {

		// this.refreshStream = new Observable<any>().startWith(null)
		this.eventStream = this.eventsFromServer().startWith([])
	}





	// REST
	// ------------------------------
	private eventsFromServer(){
		return this.http.get("http://flucht.herokuapp.com/api/v1/events")
		.map(res => res.json())
	}





	// Channel service api
	// ------------------------------
	public saveNewEvent(ev:IEvent){
		let eventString = JSON.stringify(ev)
		this.http.post("http://flucht.herokuapp.com/api/v1/event", eventString)
		.subscribe((res) => {
			console.log("Saved event with status: ", res.status)
		}, (err) => {
			console.log("Could not save event: ", err);
		})
	}

	public reloadFormServer(){

	}
}

export interface IEvent{
	name:string;
	desc:string;
	from:number;
	to:number;
}
