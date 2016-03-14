/**
 * Tabs
 * *Author*: Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)
 * *Version:* 1.0.0
 */





// External
// ------------------------------
import {Page} from 'ionic-framework/ionic';
import {Type} from 'angular2/core';



// Imports
// ------------------------------
import {EventsPage} from '../tab1-events-page/events-page';
import {ChatPage} from '../tab2-chat-page/chat-page';
import {InfoPage} from '../tab2-info-page/info-page';
import {SettingsPage} from '../tab3-settings-page/settings-page.ts';





// Tabs page
// ------------------------------
@Page({
	templateUrl: 'build/pages/tabs/tabs.html'

})
export class TabsPage {
	// this tells the tabs component which Pages
	// should be each tab's root Page
	tab1Root: Type = EventsPage;
	tab2Root: Type = InfoPage;

	constructor() {

	}
}
