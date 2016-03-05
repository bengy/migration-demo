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
export class SettingsService {





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
}

export interface ISettings {
	user: IUserSettings
}

export interface IUserSettings{
	name: string;
}