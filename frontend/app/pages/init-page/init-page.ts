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
	private currentLanguage = "Englisch"

	// constructor
	constructor(
		private http: Http,
		private params: NavParams,
		private nav: NavController,
		private settingsService: SettingsService){

		// If registered we can skip this
		if(this.settingsService.settings.didAccept){
			this.nav.push(TabsPage)
		}
	}

	clickedNextLanguage(){
		this.settingsService.setNextLanguage(false)
	}

	clickedPrevLanguage(){
		this.settingsService.setNextLanguage(true)
	}

	clickedNextPage(){

	}

	clickedAccept(){
		this.settingsService.userDidAccept()
		this.nav.push(TabsPage)
	}
}
