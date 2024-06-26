var ON_LANGUAGE_CHANGE = new Set();

const LANGUAGES = [];

function transformLanguages() {
    for (let lang of navigator.languages) {
        let transformed = lang.toLowerCase().split("-")[0];
        if (LANGUAGES.indexOf(transformed) == -1) {
            LANGUAGES.push(transformed);
        }
    }
    if (LANGUAGES.indexOf("en") == -1) {
        LANGUAGES.push(transformed);
    }
    console.log(LANGUAGES);
}
transformLanguages();

class MultilingualSwitcher extends HTMLElement {
    constructor () {
        super();
    }

    connectedCallback() {
        if (this.initialized) {
            return;
        }
        this.initialized = true;

        /** @type {Map<String,HTMLElement>} */
        this.languages = new Map();;

        for (let child of this.children) {
            let lang = child.getAttribute("lang");
            console.log(lang);
            if (!lang) {
                return;
            }
            this.languages.set(lang, child);
        }

        this.replaceChildren();

        ON_LANGUAGE_CHANGE.add(this.onLanguageChange);
        this.onLanguageChange();
    }

    onLanguageChange() {
        let elem = undefined;
        for (let lang of LANGUAGES) {
            elem = this.languages.get(lang);
            if (elem) {
                break;
            }
        }
        if (!elem) {
            return;
        }

        this.replaceChildren(elem);
    }
}

customElements.define("ml-s", MultilingualSwitcher);
