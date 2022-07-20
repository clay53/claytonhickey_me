pub struct Social {
    pub platform: &'static str,
    pub handle: &'static str,
    pub white_icon: &'static str,
    pub link: &'static str,
}

pub const SOCIALS: &'static [Social] = &[
    Social {
        platform: "Twitter",
        handle: "@ClaytonsThings",
        white_icon: "/images/socials/white_icon/twitter.svg",
        link: "https://twitter.com/ClaytonsThings"
    },
    Social {
        platform: "Mail",
        handle: "clayton@claytondoesthings.xyz",
        white_icon: "/images/socials/white_icon/mail.svg",
        link: "mailto:clayton@claytondoesthings.xyz"
    },
    Social {
        platform: "YouTube",
        handle: "Clayton Does Things",
        white_icon: "/images/socials/white_icon/youtube.png",
        link: "https://youtube.com/ClaytonDoesThings"
    },
    Social {
        platform: "Discord",
        handle: "Clayton Does Things",
        white_icon: "/images/socials/white_icon/discord.svg",
        link: "https://discord.gg/nSGT8BJ"
    },
    Social {
        platform: "Patreon",
        handle: "ClaytonDoesThings",
        white_icon: "/images/socials/white_icon/patreon.png",
        link: "https://www.patreon.com/ClaytonDoesThings"
    }
];