/**
 * Page 1
 * *Author*: Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)
 * *Version:* 1.0.0
 */





// External
// ------------------------------
import {Page, NavController} from 'ionic-framework/ionic';



// Imports
// ------------------------------
// import {EventPage} from "../event-page/event-page"
// import {SearchPage} from "../search-page/search-page"





// Favourite page
// ------------------------------
@Page({
	templateUrl: 'build/pages/tab3-settings-page/settings-page.html'
})
export class SettingsPage {





	// init
	// ------------------------------
	constructor(private nav: NavController) {
	}





	// event handler
	// ------------------------------
	// private clickedOpenTestevent() {
	// 	this.nav.push(EventPage, {id: "test"})
	// }

	// private clickedOpenSearchPage() {
	// 	this.nav.push(SearchPage)
	// }
}
