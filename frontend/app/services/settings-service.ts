/**
 * Settings service
 * *Author*: Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)
 * *Version:* 1.0.0
 */





// External
// ------------------------------
import Rx = require("rxjs")
import io = require("socket.io-client")
import {Injectable} from "angular2/core";
import {Http, URLSearchParams, Jsonp} from "angular2/http";
import _ = require("lodash");



// Imports
// ------------------------------
import {settings} from "../settings"





// Channel service
// ------------------------------
@Injectable()
export class SettingsService {





	// constructor
	// ------------------------------

	// vars
	public settings: ISettings;
	private onChange: Rx.Observable<ISettings>;

	// constructor
	constructor(private http:Http) {
		this.loadSettings()
	}

	public loadSettings():void{
		try {
			let settingsString = localStorage.getItem("settings")
			console.log("Loaded settingsString", settingsString)
			if (settingsString != null){
				this.settings = JSON.parse(settingsString)
			}
			else{
				this.settings = this.loadDeaultSettings()
			}
		}
		catch (err){
			console.error(err)
		}
	}

	public saveSettings():void{
		try {
			let settingsString = JSON.stringify(this.settings)
			localStorage.setItem("settings", settingsString)
		}
		catch (err){
			console.error(err)
		}
	}

	private loadDeaultSettings() : ISettings{
		return {
			name: "Name",
			id: "",
			language: "en",
			didRegister: false
		}
	}





	// Language
	// ------------------------------
	private langCodeMap = {
		de: {
			name: "Deutsch",
			flagName: "DE"
		},
		en: {
			name: "Englisch",
			flagName: "GB"
		}
	}

	public getPossibleLanguages(){
		return ["de", "en"]
	}

	public getLanguageFlagImageName():string{
		let lang = this.settings.language
		let flag = _.get(this.langCodeMap, lang + ".flagName", "GB")
		return flag
	}

	public getLanguageName():string{
		let lang = this.settings.language
		let name = _.get(this.langCodeMap, lang + ".name", "Englisch")
		return name
	}

	public setLanguage(langCode: ILanguage){
		this.settings.language = langCode;
		this.saveSettings()
	}

	public setNextLanguage(oppositeDirection:boolean){
		let lang = this.settings.language
		let poss = this.getPossibleLanguages()
		let idx = _.indexOf(poss, lang)
		let new_idx = (oppositeDirection ? idx - 1 : idx + 1) % poss.length;
		this.settings.language = <ILanguage>poss[new_idx]
	}





	// User
	// ------------------------------
	public registerUser(userName: string): Promise<boolean> {
		this.settings.name = userName
		this.settings.didRegister = true
		this.saveSettings()
		return Promise.resolve(true)
		// return this.http
		// 	.get(`${settings.serverEndpoint}/api/v1/`)
		// 	.map(res => res.json())
		// 	.toPromise()
		// 	.then((result) => {
		// 		// TODO:

		// 		return true
		// 	})
	}


}

export interface ISettings {
	name: string;
	id: string;
	language: ILanguage;
	didRegister: boolean;
}

type ILanguage = "en" | "de";
