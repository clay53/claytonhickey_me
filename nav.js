const PAGES = [
    {
        title: "Home",
        href: "/",
        type: "home",
    },
    {
        title: "Blog",
        href: "/blog",
        type: "blog",
    },
    {
        title: "More Nodes",
        href: "/more-nodes",
        type: "more-nodes",
    },
];

class MyNav extends HTMLElement {
    constructor() {
        super();
    }

    connectedCallback() {
        const shadow = this.attachShadow({ mode: "open" });
        const pageType = this.getAttribute("type");
        shadow.innerHTML = `<style>
            #nav, #content, #footer {
                max-width: 70rem;
            }

            #nav {
                background-color: #15222e;
                font-size: xx-large;
                margin: auto;
            }

            #nav .nav-item {
                display: inline-block;
                padding: 0.5rem 1rem;
                background-color: #182533;
            }

            #nav .nav-item a {
                color: white;
                text-decoration: none;
            }

            #nav .nav-item-selected {
                background-color: #192735;
            }
        </style>`;
        const nav = document.createElement("nav");
        nav.id = "nav";
        for (const page of PAGES) {
            const div = document.createElement("div");
            div.classList.add("nav-item");
            if (pageType === page.type) {
                div.classList.add("nav-item-selected");
            }
            const a = document.createElement("a");
            a.href = page.href;
            a.innerText = page.title;
            div.appendChild(a);
            nav.appendChild(div);
        }
        nav.innerHTML += `<div class="nav-item">
            <a href="/rss.xml" target="_BLANK">RSS</a>
        </div>`;
        nav.innerHTML += `<div class="nav-item">
            <a href="https://nextcloud.claytondoesthings.xyz/apps/listman/subscribe/9pEvpBK8" target="_blank">Mailing List</a>
        </div>`;
        shadow.appendChild(nav);
    }
}

customElements.define("my-nav", MyNav);
