class MastodonComments extends HTMLElement {
    constructor() {
        super();
    }

    connectedCallback() {
        const shadow = this.attachShadow({ mode: "open" });
        const style = document.createElement("style");
        style.innerHTML = `@import "/common.css";`;
        shadow.appendChild(style);
        const container = document.createElement("div");

        const postURL = this.getAttribute("post-url");

        if (postURL) {
            const header = document.createElement("h2");
            const headerA = document.createElement("a");
            headerA.href = postURL;
            headerA.innerText = "Comments from the Fediverse";
            header.appendChild(headerA);
            container.appendChild(header);

            const commentsURL = postURL.replace(/@.+\//, "api/v1/statuses/")+"/context"; 
            fetch(commentsURL).then(response => {
                if (!response.ok) {
                    container.innerText += "\nBad response when fetching comments";
                    response.text().then(text => container.innerText += "\n"+text);
                    return;
                }
                response.json().then(data => {
                    if (data.descendants.length === 0) {
                        container.innerHTML += `<a href="${postURL}">Be the first to comment</a>`;
                    }
                    const comments = document.createElement("div");
                    for (const descendant of data.descendants) {
                        const comment = document.createElement("div");

                        const userLine = document.createElement("div");
                        userLine.style = "display: flex; align-items: center;"

                        const avatar = document.createElement("img");
                        avatar.style = "width: 3em; border-radius: 10%;";
                        avatar.src = descendant.account.avatar_static;
                        userLine.appendChild(avatar);

                        const userA = document.createElement("a");
                        const userDisplay = document.createElement("strong");
                        userDisplay.innerText = descendant.account.display_name;
                        userA.appendChild(userDisplay);
                        userA.append(` @${descendant.account.username}@${new URL(descendant.account.url).hostname}`);
                        userA.href = descendant.account.url;
                        userLine.appendChild(userA);

                        comment.appendChild(userLine);

                        const content = document.createElement("div");
                        content.innerHTML = descendant.content;
                        comment.appendChild(content);

                        comments.appendChild(comment);
                    }
                    container.appendChild(comments);
                }).catch(e => container.innerText += `Failed to parse comments response: ${e}`);
            }).catch(e => container.innerText += `Failed send comments request: ${e}`);
        } else {
            container.innerHTML = "<h2>Comments have not yet been set up for this post</h2>";
        }

        shadow.appendChild(container);
    }
}

customElements.define("mastodon-comments", MastodonComments);
