// Item wiki thing
//
// *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
// *Version:* 0.0.1

import {Component, Output, Input, EventEmitter, ViewEncapsulation} from "angular2/core"


// component
// ------------------------------
@Component({
	selector: "dr-navbar-subtitle",
	template: `
		<ng-content></ng-content>
	`,
	styles: [
		`dr-navbar-subtitle h2 {
			color: #424242;
			padding: 0 12px;
			font-size: 2rem;
			font-weight: 500;
			display: block;
			width: 100%;
			white-space: nowrap;
			text-overflow: ellipsis;
			overflow: hidden;
		}
		`
	]
})
export class NavbarSubtitle {

	// constructor
	// ------------------------------
	constructor() {
		// todo add class to parent navbar
	}


}
