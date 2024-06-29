class CardViewer extends HTMLElement {
    constructor() {
        super();
    }

    connectedCallback() {
        const cardSetAttribute = this.getAttribute("card-set");

        const cardSet = cardSetAttribute === "projects" ? [
            IDMAP.wgpuGameOfLife,
            IDMAP.buiBasic,
            IDMAP.bui,
            IDMAP.microVSRG,
            IDMAP.claytonHickeyMeWC,
            IDMAP.claytonHickeyMe,
            IDMAP.wordSearchSolverOCR,
            IDMAP.claytonDoesThingsXYZ,
            IDMAP.carAI,
            IDMAP.soundGalaxy,
            IDMAP.meetWithPong,
            IDMAP.osuKeypad,
            IDMAP.symbolTranslator,
            IDMAP.pebbleXCTimer,
            IDMAP.imagesFromImages2,
            IDMAP.legitimateImagesFromImages,
            IDMAP.multiKahoot,
            IDMAP.givingDuo,
            IDMAP.liveStreamMusicPlayer,
        ] : cardSetAttribute === "open-source" ? [
            IDMAP.repeatOptionInfinitime,
            IDMAP.addedComentsLBRYAndroid,
            IDMAP.publishUnpublishLBRYAndroid,
        ] : cardSetAttribute === "abandoned-projects" ? [
            IDMAP.fromAnarchy,
        ] : cardSetAttribute === "blog-posts" ? [
            IDMAP.myUserControlFocusedStack,
            IDMAP.myFirstSemesterAsAUPennStudent,
            IDMAP.howBailAlgorithmsShouldBeUsed,
            IDMAP.aTheoreticalAlgorithmForDecidingBail,
            IDMAP.recommendationAlgorithmsAndEthics,
        ] : []

        const dateFormatter = new Intl.DateTimeFormat(undefined, {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });

        const container = document.createElement("div");
        container.className = "experience-container";
        for (const thingKey of cardSet) {
            const thing = IDTOCARD[thingKey];
            const thingContainer = document.createElement("div");
            thingContainer.className = "experience";

            const thingHeader = document.createElement("h3");
            
            const thingTitleLinks = document.createElement("div");
            thingTitleLinks.className = "experience-title-links";
            if (thing.links.length > 0) {
                const titleLink = document.createElement("a");
                titleLink.className = "experience-title";
                titleLink.href = thing.links[0].href;
                titleLink.innerText = thing.title;
                thingTitleLinks.appendChild(titleLink);

                for (const link of thing.links) {
                    const linkElm = document.createElement("a");
                    linkElm.href = link.href;
                    linkElm.innerHTML = link.text;
                    thingTitleLinks.appendChild(linkElm);
                }
            }
            thingHeader.appendChild(thingTitleLinks);

            thingContainer.appendChild(thingHeader);

            if (thing.thumb) {
                const img = document.createElement("img");
                img.className = "experience-img";
                img.setAttribute("src", thing.thumb.source);
                img.setAttribute("alt", thing.thumb.alt);

                if (thing.links?.length > 0) {
                    const imgLink = document.createElement("a");
                    imgLink.href = thing.links[0].href;
                    imgLink.appendChild(img);
                    thingContainer.appendChild(imgLink);
                } else {
                    thingContainer.appendChild(img);
                }
            }

            let datesText = `${thing.started ? "Started: "+dateFormatter.format(thing.started) : ""}`;

            if (thing.completed) {
                datesText += `${datesText.length > 0 ? "; " : ""}Completed: ${dateFormatter.format(thing.completed)}`;
            }

            if (thing.updated) {
                datesText += `${datesText.length > 0 ? "; " : ""}Updated: ${dateFormatter.format(thing.updated)}`;
            }

            if (thing.published) {
                datesText += `${datesText.length > 0 ? "; " : ""}Published: ${dateFormatter.format(thing.published)}`;
            }

            if (datesText.length > 0) {
                const dates = document.createElement("p");
                dates.innerText = datesText;
                thingContainer.appendChild(dates);
            }

            if (thing.skills?.length > 0) {
                const skills = document.createElement("p");
                skills.innerText = `skills: ${SKILLTONAMEMAP[thing.skills[0]]}`;
                for (let i = 1; i < thing.skills.length; i++) {
                    skills.innerText += `, ${SKILLTONAMEMAP[thing.skills[i]]}`;
                }
                thingContainer.appendChild(skills);
            }

            if (thing.description) {
                thingContainer.innerHTML += thing.description;
            }

            container.appendChild(thingContainer);
        }
        this.appendChild(container);
    }
}

customElements.define("card-viewer", CardViewer);
