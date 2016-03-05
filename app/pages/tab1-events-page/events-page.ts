/**
 * Event word list
 * *Author*: Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)
 * *Version:* 1.0.0
 */





// External
// ------------------------------
import {Http, HTTP_PROVIDERS} from "angular2/http"
import {COMMON_DIRECTIVES} from "angular2/common"
import {Page, NavController, NavParams} from 'ionic-framework/ionic';
import {Observable} from "rxjs/Observable"



// Imports
// ------------------------------
// import {EventTimePipe} from "../../pipes/event-time-pipe"
// import {EventPage} from "../event-page/event-page"
// import {EventService, ITVEventCompressed} from "../../services/event-service"
// import {WordStreamService, TVWord} from "../../services/word-service"
// import {WordPage} from "../word-page/word-page"





// Channel event list
// ------------------------------
@Page({
	templateUrl: 'build/pages/tab1-events-page/events-page.html',
	// providers:[EventService, WordStreamService],
	// pipes:[EventTimePipe],
	directives: [COMMON_DIRECTIVES]
})
export class EventsPage {





	// init
	// ------------------------------

	// var
	// private channelEvent: ITVEventCompressed;

	// private pages: IWordPage[] = []
	// private currentPage: IWordPage = null
	private wordList: any = []
	private wordStream: Observable<any[]>

	// constructor
	constructor(
		private http: Http,
		private params: NavParams,
		private nav: NavController){
		// private eventService: EventService,
		// private wordService: WordStreamService) {

		// // load channel events
		// this.channelEvent = params.get("event")
		// let streamId = _.get(this.channelEvent, "id", "test")
		// this.wordService.wordStreamForId(streamId).map(wordList => _.orderBy(wordList, "startTimeRelative")).subscribe(wordList => this.makePages(wordList))
	}

	// public makePages(wordList:TVWord[]){
	// 	let pagedWordsList = _.chunk(wordList, 5)
	// 	this.pages = pagedWordsList.map((pageWords, index) => this.makePage(pageWords, index))
	// 	let lastPage:IWordPage = _.last(this.pages)
	// 	if (this.pages.length >= 2){
	// 		if (lastPage && lastPage.words && lastPage.words.length < 5){
	// 			lastPage = this.pages[this.pages.length-2]
	// 		}
	// 	}
	// 	this.currentPage = lastPage
	// }

	// public makePage(pageWordList: TVWord[], index:number){
	// 	return {
	// 		startTimeRelativeInMinutes: _.round(_.max(_.map(pageWordList,(w:TVWord) => w.startTimeRelative)) / 1000 / 60, 0),
	// 		words: pageWordList,
	// 		index: index
	// 	}
	// }





	// event handler
	// ------------------------------

	// selected event
	// clickedWord(word) {
	// 	this.nav.push(WordPage, {"word": word})
	// }

	// clickedPreviousPage() {
	// 	console.log("Clicked prev page");
	// 	if (this.currentPage.index > 0){
	// 		this.currentPage = this.pages[this.currentPage.index - 1]
	// 	}
	// }

	// clickedNextPage(){
	// 	console.log("Clicked next page");
	// 	if (this.currentPage.index + 1 <= this.pages.length){
	// 		this.currentPage = this.pages[this.currentPage.index + 1]
	// 	}
	// }

	// isNextPageButtonDisabled(){
	// 	return (this.currentPage && this.pages) ? this.currentPage.index >= this.pages.length - 1 : true
	// }

	// isPreviousPageButtonDisabled(){
	// 	return this.currentPage ? this.currentPage.index <= 0 : true;
	// }
}

// interface IWordPage{
// 	startTimeRelativeInMinutes: number;
// 	words: TVWord[];
// 	index: number;
// }
