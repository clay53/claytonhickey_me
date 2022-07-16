use crate::{
    experiences::{
        *,
        DescriptionPart::*,
    },
    skills::Skills::*
};
use chrono::NaiveDate;

pub const CONTRIBUTIONS: &'static [Experience] = &[
    Experience {
        title: Title::Linked("Added repeat option to timer for Infinitime (open source watch firmware)", "https://github.com/InfiniTimeOrg/InfiniTime/pull/926"),
        started: Some(NaiveDate::from_ymd(2022, 1, 9)),
        completed: Some(NaiveDate::from_ymd(2022, 1, 9)),
        last_updated: Some(NaiveDate::from_ymd(2022, 2, 8)),
        skills: &[
            CPP,
            FirmwareDevelopment,
            FreeRTOSSoftware,
            LittleVGL,
        ],
        description: &[
            Paragraph(&[
                Text("I purchased a new PineTime watch which uses the Infinitime firmware. \
                I had previously used my own app (PebbleXCTimer) on my old Pebble Time for this function \
                but it's not portable and the Infinitime firmware does not have the function built in or sideloading. \
                So, I added the functionality to the timer app already built in."),
            ]),
            Paragraph(&[
                Text("Note: PR is unmerged but code is functional. They said they want it to be \
                put into a separate app but I haven't gotten to it yet.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::PR,
                destination: "https://github.com/InfiniTimeOrg/InfiniTime/pull/926"
            },
        ]
    },
    Experience {
        title: Title::Linked("Added ability to view comments to LBRY Android app", "https://github.com/lbryio/lbry-android/pull/920"),
        started: Some(NaiveDate::from_ymd(2020, 5, 28)),
        completed: Some(NaiveDate::from_ymd(2020, 5, 29)),
        last_updated: None,
        skills: &[
            AndroidNative,
            AndroidLayoutsViews,
            Java,
            RESTAPI,
            MobileApps
        ],
        description: &[
            Paragraph(&[
                Text("Comments on the LBRY website were already present but they were not available on the Android app. \
                I like to read comments so I decided I should add them to the Android app so I analyzed how their website \
                (ReactJS) was able to get comments from the LBRY REST backend server and adapted a similar technique to \
                make comments available on Android app."),
            ]),
            Paragraph(&[
                Text("Note: I only included the first page of comments in my PR because I didn't see a way with their \
                API to ensure that the comments were kept in sync (if a comment was added or removed before a user \
                would scroll, comments may be missing duplicated on the user's screen) without fetching all the pages at once \
                (defeating the purpose of pagination of saving memory and bandwidth). \
                I thought they were going to do add something to their API or something but after my PR, \
                they just went with the latter solution and fetched all the pages at once.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::PR,
                destination: "https://github.com/lbryio/lbry-android/pull/920"
            }
        ]
    },
    Experience {
        title: Title::Linked("Made it so that one can unpublish and/or delete their own videos from LBRY Android app", "https://github.com/lbryio/lbry-android/pull/1013"),
        started: Some(NaiveDate::from_ymd(2020, 10, 2)),
        completed: Some(NaiveDate::from_ymd(2020, 10, 2)),
        last_updated: None,
        skills: &[
            AndroidNative,
            AndroidLayoutsViews,
            Java,
            RESTAPI,
            MobileApps,
        ],
        description: &[
            Paragraph(&[
                Text("Unpublishing and deleting videos are separate actions on the LBRY platform. \
                However, the LBRY Android app did not make this distinction and performed both actions. \
                So, I added another button and fixed some UI logic around it.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::PR,
                destination: "https://github.com/lbryio/lbry-android/pull/1013"
            }
        ]
    }
];