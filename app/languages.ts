/**
 * Translation dictionary, safe translations with usage of key...
 * if something is not translated, it will fallback to use the key.
 *
 *
 * *Author*: Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)
 * *Version:* 1.0.0
 */

export module translations {
	export var translations = {
		welcome : {
			de: "Willkommen"
			en: "welcome"
		}
	}

	export function getTranslation(key: string, langCode: string): string = {
		if (translations[key] != null && translations[key][langCode] != null){
			return translations[key][langCode]
		}
		else{
			return key
		}
	}

	// TODO export pipe that uses settings to transform to current language
}