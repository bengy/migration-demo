/**
 * Page 1
 * *Author*: Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)
 * *Version:* 1.0.0
 */





// External
// ------------------------------
import {Page, NavController, ViewController} from 'ionic-framework/ionic';
import {DatePicker} from "ionic-native"



// Imports
// ------------------------------
import {EventService, IEvent} from "../../services/event-service"
// import {SearchPage} from "../search-page/search-page"
import {DateUtils} from "../../common-utils"





// Favourite page
// ------------------------------
@Page({
	templateUrl: 'build/pages/event-editor-page/event-editor-page.html',
	providers: [EventService]
})
export class EventEditorPage {



	private eventData: IEvent = {
		name: "",
		desc: "",
		from: Date.now(),
		to: Date.now()
	}
	private fromDate: string = DateUtils.currentDateInputValue();
	private fromTime: string = DateUtils.currentTimeInputValue();
	private toDate: string = DateUtils.currentDateInputValue();
	private toTime: string = DateUtils.currentTimeInputValue();





	// init
	// ------------------------------
	constructor(
		private nav: NavController,
		private eventService: EventService,
		private viewCtrl: ViewController) {
	}





	// Event handler
	// ------------------------------
	clickedClose(){
		this.viewCtrl.dismiss(null)
	}

	clickedSave(){
		this.eventData.from = DateUtils.dateAndTimeToUTCEpoch(this.fromDate, this.fromTime)
		this.eventData.to = DateUtils.dateAndTimeToUTCEpoch(this.toDate, this.toTime)
		console.log("Saving event: ", this.eventData)
		this.eventService.saveNewEvent(this.eventData)
		this.viewCtrl.dismiss(null)
	}
}
