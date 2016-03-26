/**
 * Common utilities
 * *Author*: Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)
 * *Version:* 0.0.1
 */





// Date
// ------------------------------
export module DateUtils{

	// Returns current date with "yyyy-mm-dd" format
	export function currentDateInputValue(){
		return dateToDateInputValue(new Date())
	}

	// Returns given date with "yyyy-mm-dd" format
	export function dateToDateInputValue(date:Date):string{
		let local = date
		local.setMinutes(local.getMinutes() - local.getTimezoneOffset())
		return local.toJSON().slice(0,10)
	}


	// Returns current date with "hh:mm" format
	export function currentTimeInputValue(){
		return dateToTimeInputValue(new Date())
	}

	// Returns given date with "hh:mm" format
	export function dateToTimeInputValue(date:Date):string{
		let local = date
		local.setMinutes(local.getMinutes() - local.getTimezoneOffset())
		return local.toJSON().slice(11,16)
	}

	// Return time utc epoch from date and time string
	export function dateAndTimeToUTCEpoch(date:string, time:string){
		let dateString = date + "T" + time
		return Date.parse(dateString)
	}
}
