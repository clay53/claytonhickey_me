var ON_LANGUAGE_CHANGE = new Set();

const LANGUAGES = [];

function transformLanguages() {
    while (LANGUAGES.length > 0) {
        LANGUAGES.pop();
    }
    let preferredLang = localStorage.getItem("preferred-lang");
    if (preferredLang) {
        LANGUAGES.push(preferredLang);
    }
    for (let lang of navigator.languages) {
        let transformed = lang.toLowerCase().split("-")[0];
        if (LANGUAGES.indexOf(transformed) == -1) {
            LANGUAGES.push(transformed);
        }
    }
    if (LANGUAGES.indexOf("en") == -1) {
        LANGUAGES.push(transformed);
    }
}
transformLanguages();

function setPreferredLang(lang) {
    localStorage.setItem("preferred-lang", lang);
    transformLanguages();
    for (let fn of ON_LANGUAGE_CHANGE) {
        try { fn(); } catch {}
    }
}

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
            if (!lang) {
                return;
            }
            this.languages.set(lang, child);
        }

        this.replaceChildren();

        this.onLanguageChange = () => {
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

        ON_LANGUAGE_CHANGE.add(this.onLanguageChange);
        this.onLanguageChange();
    }

    disconnectedCallback() {
        ON_LANGUAGE_CHANGE.delete(this.onLanguageChange);
    }
}

customElements.define("ml-s", MultilingualSwitcher);
