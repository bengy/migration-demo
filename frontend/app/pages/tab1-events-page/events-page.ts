/**
 * Event list
 * *Author*: Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)
 * *Version:* 1.0.0
 */





// External
// ------------------------------
import {Http, HTTP_PROVIDERS} from "angular2/http"
import {COMMON_DIRECTIVES} from "angular2/common"
import {Page, NavController, NavParams, Modal} from 'ionic-framework/ionic';
import {Observable} from "rxjs/Observable"
import 'rxjs/add/operator/map'
import 'rxjs/add/operator/startWith'



// Imports
// ------------------------------
import {EventEditorPage} from "../event-editor-page/event-editor-page"
import {EventService, IEvent} from "../../services/event-service"





// Channel event list
// ------------------------------
@Page({
	templateUrl: 'build/pages/tab1-events-page/events-page.html',
	providers:[EventService],
	directives: [COMMON_DIRECTIVES]
})
export class EventsPage {





	// init
	// ------------------------------

	// var
	private eventList: any = []
	private eventStream: Observable<any[]>

	// constructor
	constructor(
		private http: Http,
		private params: NavParams,
		private nav: NavController,
		private eventService: EventService) {
		this.eventStream = eventService.eventStream;
	}





	// event handler
	// ------------------------------
	private clickedAddEvent() {
		let eventModal = Modal.create(EventEditorPage)
		this.nav.present(eventModal)
	}

	//
	doRefresh(e:Event){

	}
}
