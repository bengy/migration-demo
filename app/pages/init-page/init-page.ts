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
import {SettingsService} from "../../services/settings-service"
import {TabsPage} from "../tabs/tabs"





// Channel event list
// ------------------------------
@Page({
	templateUrl: 'build/pages/init-page/init-page.html',
	providers:[SettingsService],
	directives: [COMMON_DIRECTIVES]
})
export class InitPage {





	// init
	// ------------------------------

	// var
	private currentIndex = 0

	// constructor
	constructor(
		private http: Http,
		private params: NavParams,
		private nav: NavController){
	}

	clickedNextPage(){

	}

	clickedAccept(){
		this.nav.push(TabsPage)
	}
}
