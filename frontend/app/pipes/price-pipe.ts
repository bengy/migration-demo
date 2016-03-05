/**
 * Price pipe
 * *Author*: Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)
 * *Version:* 1.0.0
 */





// External
// ------------------------------
import {Pipe} from 'angular2/core'
import * as moment from 'moment'
import * as _ from "lodash"





// Price pipe
// ------------------------------
@Pipe({
	name: "priceFilter"
})
export class PriceFilterPipe{
	transform(value) {
		if (_.isString(value)) {
			let priceInCents = _.parseInt(value)
			let priceInEuro = (priceInCents / 100).toFixed(2)
			return `${priceInEuro}€`
		}
		else if(_.isNumber(value)) {
			return `${value}€`
		}
		else {
			return "Buy"
		}
	}
}