// Item wiki thing
//
// *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
// *Version:* 0.0.1

import {Component, Output, Input, EventEmitter, ViewEncapsulation, Inject, ElementRef, OnInit} from "angular2/core"
import {IONIC_DIRECTIVES} from 'ionic-framework/ionic';
import {EventService, ITVEventCompressed} from "../services/event-service"
import {ChannelService, ITvChannel} from "../services/channel-service"
import {EventTimePipe} from "../pipes/event-time-pipe"





// component
// ------------------------------
@Component({
	selector: "channel-component",
	providers: [],
	directives: [IONIC_DIRECTIVES],
	pipes: [EventTimePipe],
	template: `
	<ion-item>
		<ion-avatar item-left>
			<img [src]="channelService.getLogoUrlForChannel(channel)">
		</ion-avatar>
		<h2>{{channel.info.name}}</h2>
		<button clear item-right (click)="openEvent.emit(currentEvent)">View</button>
	</ion-item>
	`
})
export class ChannelComponent implements OnInit {





	// vars
	// ------------------------------
	@Output() private openEvent = new EventEmitter();
	@Input() private channel: ITvChannel;
	private currentEvent: ITVEventCompressed;





	// constructor
	// ------------------------------
	constructor(
		private elementRef: ElementRef,
		private eventService: EventService,
		private channelService: ChannelService){
	}

	// on init
	ngOnInit(){
		this.loadNextEvent()
	}





	// eventhandler
	// ------------------------------
	private eventList = []
	loadNextEvent(){
		let eventPromise = this.eventList.length > 0 ? Promise.resolve(this.eventList) : this.eventService.getLimitedChannelEvents(this.channel.id, 5).toPromise()
		eventPromise.then(newEventList => {

			// TODO: add random offset
			if (_.isEmpty(newEventList)) { setTimeout(() => this.loadNextEvent, 5 * 60 * 1000); return}
			this.currentEvent= _.first(newEventList)
			this.eventList = _.tail(newEventList)
			let timeDiff = (Date.now() * 1000) - this.currentEvent.info.endTimeUtcEpoch
			if (timeDiff <= 0) { () => this.loadNextEvent(); return }
			else{ setTimeout(() => this.loadNextEvent, timeDiff); return }
		})
	}
}
