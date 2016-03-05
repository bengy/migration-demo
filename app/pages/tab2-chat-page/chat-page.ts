/**
 * Search page
 * *Author*: Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)
 * *Version:* 1.0.0
 */





// External
// ------------------------------
import {Page, NavController} from 'ionic-framework/ionic';
import {Http, HTTP_PROVIDERS} from "angular2/http"
import {COMMON_DIRECTIVES, DatePipe, Control} from 'angular2/common'
import {Observable} from "rxjs/Observable"



// Imports
// ------------------------------
// import {EventPage} from "../event-page/event-page"
// import {EventTimePipe} from "../../pipes/event-time-pipe"
// import {SearchService, ISearchResult} from "../../services/search-service"
// import {ChannelEventList} from "../channel-event-list/channel-event-list"





// Page
// ------------------------------
@Page({
	templateUrl: 'build/pages/search-page/search-page.html',
	directives: [COMMON_DIRECTIVES]
	// pipes: [EventTimePipe],
	// providers: [SearchService]
})
export class ChatPage {





	// init
	// ------------------------------
	private searchResults: Observable<string[]> = null;
	private searchQuery = new Control();

	constructor(private http: Http, private nav: NavController) {
		// this.searchResults = this.searchQuery.valueChanges
		// 	.debounceTime(400)
		// 	.distinctUntilChanged()
		// 	.switchMap((term: string) => this.searchService.search(term))
	}





	// view delegation
	// ------------------------------
	private onPageWillLeave() {
		this.searchResults
	}





	// event handler
	// ------------------------------
	// private clickedSearchResult(result: ISearchResult) {
	// 	console.log(result)
	// 	if (result.category == "channel") {
	// 		this.nav.push(ChannelEventList, {id: result.id})
	// 	}
	// }
}

