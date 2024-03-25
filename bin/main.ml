type htmlChildren = SelfClosing | List of string list * bool;;

type htmlPropertyData = PBool of bool | PInt of int | PFloat of float | PString of string;;

let rec html_properties_string properties =
    begin match properties with
        | [] -> ""
        | (tag, property_value) :: next_properties ->
                " " ^ begin match property_value with
                    | PBool false -> ""
                    | PBool true -> tag 
                    | PInt i -> tag ^ "=" ^ string_of_int i
                    | PFloat f -> tag ^ "=" ^ string_of_float f
                    | PString s -> tag ^ "=\"" ^ s ^ "\""
                end ^ html_properties_string next_properties
    end
;;

let html_element_string (tag:string) (properties:(string*htmlPropertyData) list) (children:htmlChildren) =
    let properties_string = html_properties_string properties in
    let start = "<" ^ tag ^ properties_string ^ ">" in
    begin match children with
        | SelfClosing -> start
        | List (elements, ends_at_eof) -> start ^ String.concat "" elements ^ if ends_at_eof then "" else "</" ^ tag ^ ">"
    end
;;

let meta_string name content = html_element_string "meta" [("name", PString name); ("content", PString content)] SelfClosing;;

let meta_link_string rel ty href = html_element_string
    "link"
    (("rel", PString rel) :: ((begin match ty with | None -> [] | Some t -> [("type", PString t)] end) @ [("href", PString href)]))
    SelfClosing
;;

let script_import_string src = html_element_string "script" [("src", PString src)] (List ([], false));;

let html_header level content = html_element_string ("h" ^ string_of_int level) [] (List (content, false));;

let html_section id header level content = html_element_string "section" [("id", PString id)] (List (
     html_header level [header] :: content
, false));;

let html_p content = html_element_string "p" [] (List (content, false));;

let html_a href target_blank content = html_element_string
    "a"
    (("href", PString href) :: (if target_blank then [("target", PString "_BLANK")] else []))
    (List (content, false))
;;

let html_img src alt extra_props = html_element_string
    "img"
    (("src", PString src) :: ("alt", PString alt) :: extra_props)
    SelfClosing
;;

let html_br = "<br>";;

let html_div props content = html_element_string "div" props (List (content, false));;

let meta_og types content =
    html_element_string
        "meta"
        [
            (
                "property",
                PString ("og:" ^ (String.concat ":" types))
            );
            ("content", PString content)
        ]
        SelfClosing

let footer = html_element_string "footer" [] (List ([
    "<hr>";
    "Check out the code on ";
    html_a "https://github.com/clay53/claytonhickey_me" false ["GitHub.com"];
    html_div [("id", PString "footer-social-media")] [
        html_a "https://twitter.com/ClaytonsThings" true [html_img "/images/socials/white_icon/twitter.svg" "Twitter" []];
        html_a "mailto:clayton@claytondoesthings.xyz" true [html_img "/images/socials/white_icon/mail.svg" "Mail" []];
        html_a "https://youtube.com/ClaytonDoesThings" true [html_img "/images/socials/white_icon/youtube.png" "YouTube" []];
        html_a "https://discord.gg/nSGT8BJ" true [html_img "/images/socials/white_icon/discord.svg" "Discord" []];
        html_a "https://www.patreon.com/ClaytonDoesThings" true [html_img "/images/socials/white_icon/patreon.png" "Patreon" []];
    ]
], false));;

type page_nav_type =
    | Home
    | Blog
    | MoreNodes
;;

let build_page title description canonical_path nav_type og_image_path content =
    "<!DOCTYPE html>"
    ^ html_element_string "html" [] (List ([], true))
    ^ html_element_string "head" [] (List ([
        html_element_string "meta" [("charset", PString "UTF-8")] SelfClosing;
        html_element_string "title" [] (List ([title], false));
        meta_string "description" description;
        meta_link_string "canonical" None ("https://claytonhickey.me/" ^ canonical_path);
        meta_string "viewport" "width=device-width, initial-scale=1";
        meta_link_string "stylesheet" (Some "text/css") "/common.css";
        meta_link_string "icon" (Some "image/ico") "/favicon.ico";
        meta_og ["title"] title;
        meta_og ["type"] "website";
        meta_og ["description"] description;
        meta_og ["url"] ("https://claytonhickey.me/" ^ canonical_path);
        meta_og ["image"] begin match og_image_path with
            | None -> "https://claytonhickey.me/images/headshot.jpg"
            | Some path -> "https://claytonhickey.me/" ^ path
        end;
        html_element_string "link" [("rel", PString "alternate"); ("type", PString "application/rss+xml"); ("title", PString "Clayton Hickey's Blog"); ("href", PString "/rss.xml")] SelfClosing;
        script_import_string "/nav.js";
    ], false))
    ^ html_element_string "body" [] (List ([
        html_element_string "my-nav" [("type", PString begin match nav_type with
            | Home -> "home"
            | Blog -> "blog"
            | MoreNodes -> "more-nodes"
        end)] (List ([], false));
        html_element_string "main" [("id", PString "content")] (List (content, false));
        footer;
    ], true))
;;

let card_viewer_elem card_set = html_element_string "card-viewer" [("card-set", PString card_set)] (List ([], false));;

module Date =
    struct
        type date = int * int * int * int * int * int * string

        let new_date year month day hour minute second timezone : date = (year, month, day, hour, minute, second, timezone)
        
        let new_date_et year month day hour minute second : date = new_date year month day hour minute second "ET"

        let compare (a:date) (b:date) =
            let rec chain_comparisons l1 l2 =
                begin match (l1, l2) with
                    | ([], []) -> 0
                    | (h1 :: t1, h2 :: t2) ->
                        begin match Int.compare h1 h2 with
                            | 0 -> chain_comparisons t1 t2
                            | r -> r
                        end
                    | _ -> failwith "different lengths"
                end
            in
            let (year1, month1, day1, hour1, minute1, second1, _) = a in
            let (year2, month2, day2, hour2, minute2, second2, _) = b in
            chain_comparisons [year1; month1; day1; hour1; minute1; second1] [year2; month2; day2; hour2; minute2; second2]

        let year ((y,_,_,_,_,_,_):date) = y

        let month ((_,m,_,_,_,_,_):date) = m

        let day ((_,_,d,_,_,_,_):date) = d

        let en_month_from_int m =
            begin match m with
                | 1 -> "January"
                | 2 -> "February"
                | 3 -> "March"
                | 4 -> "April"
                | 5 -> "May"
                | 6 -> "June"
                | 7 -> "July"
                | 8 -> "August"
                | 9 -> "September"
                | 10 -> "October"
                | 11 -> "November"
                | 12 -> "December"
                | _ -> failwith ("Invalid month int: " ^ string_of_int m)
            end
        let weekday_number (year, month, day, _hour, _minute, _second, _timezone) =
                (((1+5*((year-1) mod 4)+4*((year-1) mod 100)+6*((year-1) mod 400)) mod 7)
                + begin match month with
                    | 1 -> 0
                    | 2 -> 3
                    | 3 -> if year mod 4 = 0 then 4 else 3
                    | 4 -> if year mod 4 = 0 then 0 else 6
                    | 5 -> if year mod 4 = 0 then 2 else 1
                    | 6 -> if year mod 4 = 0 then 5 else 4
                    | 7 -> if year mod 4 = 0 then 0 else 6
                    | 8 -> if year mod 4 = 0 then 3 else 2
                    | 9 -> if year mod 4 = 0 then 6 else 5
                    | 10 -> if year mod 4 = 0 then 1 else 0
                    | 11 -> if year mod 4 = 0 then 4 else 3
                    | 12 -> if year mod 4 = 0 then 6 else 5
                    | _ -> failwith ("invalid month " ^ string_of_int month)
                end
                + day
            ) mod 7

        let et_is_edt date =
            let (year, month, _day, _hour, _minute, _second, timezone) = date in
            if not (String.equal timezone "ET") then failwith "timzone is not ET";
            if month < 3 then
                false
            else if month = 3 then
                let first_march_weekday = weekday_number (new_date_et year month 1 0 0 0) in
                let second_sunday_day =
                    if first_march_weekday <= 1 then
                        1+1-first_march_weekday+7
                    else
                        1+8-first_march_weekday+7
                in
                let comparison = compare date (new_date_et year month second_sunday_day 3 0 0) in
                if comparison >= 0 then
                    true
                else
                    false
            else if month > 3 && month < 11 then
                true
            else if month = 11 then
                let first_nov_weekday = weekday_number (new_date_et year month 1 0 0 0) in
                let first_sunday_day =
                    if first_nov_weekday <= 1 then
                        1+1-first_nov_weekday
                    else
                        1+8-first_nov_weekday
                in
                let early_comparison = compare date (new_date_et year month first_sunday_day 1 0 0) in
                if early_comparison < 0 then
                    true
                else if early_comparison = 0 || (
                    let late_comparison = compare date (new_date_et year month first_sunday_day 2 0 0) in
                    late_comparison <= 0) then
                    failwith "Can't convert ET into EDT or EST stably between 1 and 2am on the first sunday of November"
                else
                    false
            else
                false

        let as_rss_date date =
            let (year, month, day, hour, minute, second, og_timezone) = date in
            let timezone =
                begin match og_timezone with
                    | "ET" -> if et_is_edt date then "EDT" else "EST"
                    | _ -> og_timezone
                end
            in
            let weekday_number = weekday_number date in
            let weekday_string = begin match weekday_number with
                | 2 -> "Mon"
                | 3 -> "Tue"
                | 4 -> "Wed"
                | 5 -> "Thu"
                | 6 -> "Fri"
                | 0 -> "Sat"
                | 1 -> "Sun"
                | _ -> failwith ("invalid weekday " ^ string_of_int weekday_number)
            end in
            let month_string = begin match month with
                | 1 -> "Jan"
                | 2 -> "Feb"
                | 3 -> "Mar"
                | 4 -> "Apr"
                | 5 -> "May"
                | 6 -> "Jun"
                | 7 -> "Jul"
                | 8 -> "Aug"
                | 9 -> "Sep"
                | 10 -> "Oct"
                | 11 -> "Nov"
                | 12 -> "Dec"
                | _ -> failwith ("invalid month " ^ string_of_int month)
            end in
            let two_digit_int_string i = if i < 10 then "0" ^ string_of_int i else string_of_int i in
            weekday_string ^ ", " ^ two_digit_int_string day ^ " " ^ month_string ^ " " ^ string_of_int year ^ " " ^ two_digit_int_string hour ^ ":" ^ two_digit_int_string minute ^ ":" ^ two_digit_int_string second ^ " " ^ timezone
    end
;;

let read_file_to_string file =
    let ic = open_in_bin file in
    let s = really_input_string ic (in_channel_length ic) in
    close_in ic;
    s
;;

let read_file_to_bytes file =
    let ch = open_in_bin file in
    let len = in_channel_length ch in
    let buf = Bytes.create len in
    really_input ch buf 0 len;
    close_in ch;
    buf
;;

let write_string_to_file file str =
    let oc = open_out file in
    output_string oc str;
    close_out oc;
;;

let write_bytes_to_file file by =
    let oc = open_out_bin file in
    output_bytes oc by;
    close_out oc;
;;

let copy_file src dest = write_bytes_to_file dest (read_file_to_bytes src);;

let rec copy_fs src dest =
    if Sys.is_directory src then (
        Sys.mkdir dest 0o777;
        (Array.iter (fun n -> copy_fs (src ^ "/" ^ n) (dest ^ "/" ^ n))) (Sys.readdir src);)
    else
        copy_file src dest
;;

if Sys.file_exists "www" then
    let rec rmrf path = if Sys.is_directory path then
        (Array.iter (fun n -> rmrf (path ^ "/" ^ n)) (Sys.readdir path);
        Sys.rmdir path)
    else
        Sys.remove path
    in
    rmrf "www"
;;

Sys.mkdir "www" 0o777
;;

let sitemap_entries = Buffer.create 1000;;

let add_sitemap_entry path changefreq priority = Buffer.add_string sitemap_entries (
    "<url><loc>https://claytonhickey.me/" ^ path ^ "</loc><changefreq>" ^ changefreq ^ "</changefreq><priority>" ^ priority ^ "</priority></url>"
);;

let build_tidbit header details =
    html_element_string "div" [] (List ([
        html_element_string "h2" [("class", PString "tidbit-subheader")] (List ([header], false));
        html_element_string "p" [("class", PString "tidbit-details")] (List ((
            begin match details with
                | [] -> []
                | first :: tl -> first :: (List.fold_right (fun x acc -> html_br :: x :: acc) tl [])
            end
        ), false))
    ], false))
in
write_string_to_file "www/index.html" (build_page
    "Clayton Hickey"
    "Clayton Hickey's Website"
    ""
    Home
    None
    [
        script_import_string "/stuff.js";
        script_import_string "/cardViewer.js";
        html_element_string "section" [("id", PString "introduction")] (List ([
            html_div [] [
                html_header 1 ["Clayton Hickey"];
                html_p [
                    "I am currently working at GameSense Sports working as a fullstack web/mobile/deployment/software engineer. For them, I have developed a web-based video editor using React, Rust, Actix, FFMpeg, PHP, Laravel, Auth0, and AWS used to create pitch recognition training videos used by MLB teams based on the research and direction of Dr. Peter Fadde. I'm currently studying Bioengineering and Computer Science at the University of Pennsylvania. I have been teaching myself programming since 2nd grade by doing projects I was interested in. I'm currently working on developing an educational software suite to compete with Anki, Quizlet, Kahoot, GimKit, Google Classroom, and Duolingo that runs on all platforms (desktop, web, &amp; mobile) and is federated-like (similar to Mastodon), free, and open source. The language learning portion of the suite's development is being documented on 𝕏: ";
                    html_a "https://twitter.com/tutor_engine" true ["@tutor_engine"]
                ];
            ];
            html_img "/images/headshot.jpg" "Headshot of Clayton Hickey" [("id", PString "headshot")];
        ], false));
        html_section "experiences" "Experiences" 1 [
            html_section "projects" "Projects" 2 [card_viewer_elem "projects"];
            html_section "open-source" "Open Source Contributions" 2 [card_viewer_elem "open-source"];
            html_section "abandoned-projects" "Abandoned Projects" 2 [card_viewer_elem "abandoned-projects"];
        ];
        html_section "tidbits" "Tidbits" 1 [
            html_div [("id", PString "tidbits-container")] [
                build_tidbit "Desktop: custom" [
                    "OS: Windows 10";
                    "CPU: i7-6700";
                    "GPU: RTX 2060";
                    "RAM: 32GB";
                    "Monitors: 1 to 1.5 (average 1.25)"
                ];
                build_tidbit "Laptop: Framework 13" [
                    "OS: NixOS";
                    "WM: Sway";
                    "CPU: 12 Gen Intel i5-1240P0";
                    "RAM: 64GB"
                ];
                build_tidbit "Programming Environment" [
                    "IDE: NeoVim";
                    "Terminal: Alacritty";
                    "Shell: Bash";
                    "Release channel prefrence: LTS"
                ];
                build_tidbit "Personal Server" [
                    "Host: Linode";
                    "RAM: 2GB";
                    "CPU: 1 core Xeon E5-2697";
                    "OS: NixOS";
                    "Proxy: Nginx";
                    "Server: Nextcloud"
                ];
                build_tidbit "&lt;3 Software Stack" [
                    "Backend: Rust";
                    "GUI Framework: Flutter"
                ];
                build_tidbit "&lt;3 Web Stack" [
                    "Backend: Rust w/ Axum";
                    "Client: static HTML/CSS/JS generated from OCaml";
                    "Database: Postgres"
                ];
                build_tidbit "HS Clubs" [
                    "<a href=\"https://tsaweb.org/\">TSA</a>: President";
                    "<a href=\"https://tsaweb.org/teams\">TEAMS</a>: President";
                    "<a href=\"https://www.soinc.org/\">Science Olympiad</a>: President";
                    "Esports: Vice President";
                    "GMSGA: Historian"
                ];
                build_tidbit "Sports" [
                    "Cross Country";
                    "Winter/Spring Track";
                    "Tennis";
                ];
            ]
        ];
    ]
);;


add_sitemap_entry "" "weekly" "1";;

let rss_items = Buffer.create 1000;;

let add_rss_item title description canonical_path date html_content =
    Buffer.add_string rss_items (
        "<item><title>" ^ title ^ "</title><description>" ^ description ^ "</description><link>https://claytonhickey.me/" ^ canonical_path ^ "</link><guid>https://claytonhickey.me/" ^ canonical_path ^ "</guid><pubDate>" ^ Date.as_rss_date date ^ "</pubDate><content:encoded><![CDATA[" ^ html_content ^ "]]></content:encoded></item>"
    );
;;

Sys.mkdir "www/blog" 0o777
;;

let blog_post_cards = Buffer.create 1000;;

let add_blog_post_card title description canonical_path pub_date thumb_path thumb_alt =
    Buffer.add_string blog_post_cards (html_div [("class", PString "experience")] [
        html_header 3 [
            html_div [("class", PString "experience-title-links")] [
                html_element_string "a" [("class", PString "experience-title"); ("href", PString ("/" ^ canonical_path))] (List ([title], false));
                html_a ("/" ^ canonical_path) false ["Read"]
            ]
        ];
        html_a ("/" ^ canonical_path) false [html_img ("/" ^ thumb_path) thumb_alt [("class", PString "experience-img")]];
        html_p [Date.as_rss_date pub_date];
        html_p [description];
    ]);
;;

let add_blog_post_raw title description html_content rss_content canonical_path date thumb_path thumb_alt assets mastodon_thread =
    let fs_path = "www/" ^ canonical_path in
    Sys.mkdir fs_path 0o777;
    let full_html = build_page
        (title ^ " - Clayton Hickey")
        description
        canonical_path
        Blog
        (Some thumb_path)
        (html_content :: [
            html_div [] [
                html_p ["MLA citation:"];
                let href = "https://claytonhickey.me/" ^ canonical_path in
                html_p ["Hickey, C. L. (" ^ string_of_int (Date.year date) ^ ", " ^ Date.en_month_from_int (Date.month date) ^ " " ^ string_of_int (Date.day date) ^ "). <i>" ^ title ^ "</i>. Clayton Hickey. " ^ html_a href false [href] ^ "."];
            ];
            script_import_string "/mastodonComments.js";
            begin match mastodon_thread with
                | None -> html_element_string "mastodon-comments" [] (List ([], false))
                | Some thread_url -> html_element_string "mastodon-comments" [("post-url", PString thread_url)] (List ([], false))
            end;
        ])
    in
    write_string_to_file
        (fs_path ^ "/index.html") 
        full_html
    ;
    List.iter (fun (n, b) -> write_bytes_to_file (fs_path ^ "/" ^ n) b) assets;
    add_rss_item title description canonical_path date rss_content;
    add_blog_post_card title description canonical_path date thumb_path thumb_alt;
    add_sitemap_entry canonical_path "yearly" "0.9";
;;

let add_blog_post title description html_content rss_content folder_name date thumb_path thumb_alt assets mastodon_thread = add_blog_post_raw
    title
    description
    html_content
    rss_content
    ("blog/" ^ folder_name)
    date
    thumb_path
    thumb_alt
    assets
    mastodon_thread
;;

let add_blog_post_from_folder title description date folder_name thumb_path thumb_alt mastodon_thread =
    let html = read_file_to_string ("blogs-v0/" ^ folder_name ^ "/index.html") in
    let asset_filenames = List.filter (fun f -> not (String.equal f "index.html")) (Array.to_list (Sys.readdir ("blogs-v0/" ^ folder_name))) in
    let assets = List.map
        (fun n -> (n, read_file_to_bytes ("blogs-v0/" ^ folder_name ^ "/" ^ n)))
        asset_filenames
    in
    add_blog_post title description html html folder_name date thumb_path thumb_alt assets mastodon_thread
;;

let add_blog_post_from_folder_thumb_contained title description date folder_name thumb_filename thumb_alt mastodon_thread = add_blog_post_from_folder title description date folder_name ("blog/" ^ folder_name ^ "/" ^ thumb_filename) thumb_alt mastodon_thread;;

let parsed_obsidian_posts = List.stable_sort
    (fun a b ->
        let (_, _, _, _, _, _, _, _, _, date1, _) = a in
        let (_, _, _, _, _, _, _, _, _, date2, _) = b in
        -(Date.compare date1 date2)
    )
    (List.map (fun n ->
        let ic = open_in ("blogs-v1/" ^ n ^ "/index.html") in
        let title = Option.get (In_channel.input_line ic) in
        let description = Option.get (In_channel.input_line ic) in
        let thumb_path = Option.get (In_channel.input_line ic) in
        let thumb_alt = Option.get (In_channel.input_line ic) in
        let date_string = In_channel.input_line ic in
        let pub_date =
            begin match date_string with
                | None -> failwith ("missing date string in " ^ n)
                | Some s ->
                    begin match String.split_on_char '-' s with
                        | [year; month; day; hour; minute; second] ->
                            Date.new_date_et (int_of_string year) (int_of_string month) (int_of_string day) (int_of_string hour) (int_of_string minute) (int_of_string second)
                        | _ -> failwith ("malformed date on " ^ n)
                    end
            end
        in
        let edit_date_string = Option.get (In_channel.input_line ic) in
        let mastodon_thread_string = Option.get (In_channel.input_line ic) in
        let mastodon_thread = if String.length mastodon_thread_string = 0 then None else Some mastodon_thread_string in
        let html = In_channel.input_all ic in
        let assets = List.map
            (fun n2 -> (n2, read_file_to_bytes ("blogs-v1/" ^ n ^ "/" ^ n2)))
            (List.filter (fun n2 -> not (String.equal n2 "index.html")) (Array.to_list (Sys.readdir ("blogs-v1/" ^ n))))
        in
        (title, description, n, thumb_path, thumb_alt, mastodon_thread, html, html, assets, pub_date, None)
    ) (Array.to_list (Sys.readdir "blogs-v1")))
;;

List.iter (fun (title, description, folder_name, thumb_path, thumb_alt, mastodon_thread, html_content, rss_content, assets, pub_date, _) -> add_blog_post
    title
    description
    html_content
    rss_content
    folder_name
    pub_date
    thumb_path
    thumb_alt
    assets
    mastodon_thread
) parsed_obsidian_posts;;

add_blog_post_from_folder_thumb_contained "My User-Control-Focused Stack" "How I use various systems like RSS, Mastodon/Activity Pub, Linode, Nextcloud, and Nix to increase my computational independence." (Date.new_date_et 2024 2 11 0 32 0) "my-user-control-focused-stack" "thumb.png" "Various logos including RSS, Mastodon, Nextcloud, Linode, Nix, Vaultwarden" (Some "https://cdt.social/@clayton/111736390933029700");;

add_blog_post_from_folder "My first semester as a UPenn student" "A description of my semester year as a student at the University of Pennsylvania (UPenn)" (Date.new_date_et 2023 12 29 3 30 0) "my-first-semester-as-a-upenn-student" "images/misc/dubois_college_house.jpg" "W.E.B. Dubois College House" (Some "https://cdt.social/@clayton/111678480314790286");;

add_blog_post_from_folder_thumb_contained "How Should Bail Algorithms Be Used" "Should bail algorithms be used today or in the future? Here's my stance. Written for Tech Roulette 2021, P4M3 - Justice Matrix" (Date.new_date_et 2021 7 10 0 0 0) "how-should-bail-algorithms-be-used" "judge-handing-computer-an-L.png" "A judge handing a computer an L" (Some "https://cdt.social/@clayton/111678731664758658");;

add_blog_post_from_folder_thumb_contained "A Theoretical Algorithm for Deciding Bail" "A quick look into creating a computer algorithm for deciding bail for someone awaiting trial. Written for Tech Roulette 2021, P4M2 - Justice Matrix" (Date.new_date_et 2021 7 10 0 0 0) "a-theoretical-algorithm-for-deciding-bail" "computer-holding-freedom-random.png" "Your freedom will cost 100 million dollars" (Some "https://cdt.social/@clayton/111678742369126381");;

add_blog_post_from_folder_thumb_contained "Recommendation Algorithms and Ethics" "A not-very-short not-very-source-heavy dive into recommendation algorithms and the ethical questions surrounding them. Written for Tech Roulette 2021, P4M1 - Justice Matrix" (Date.new_date_et 2021 7 9 0 0 0) "recommendation-algorithms-and-ethics" "youtube-handing-viewer-burning-baby.png" "YouTube logo handing viewer a burning baby" (Some "https://cdt.social/@clayton/111678761831022044");;

write_string_to_file "www/rss.xml" (
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><rss version=\"2.0\" xmlns:content=\"http://purl.org/rss/1.0/modules/content/\" xmlns:atom=\"http://www.w3.org/2005/Atom\"><channel><title>Clayton Hickey's Blog</title><link>https://claytonhickey.me/blog</link><description>The latest blog posts by Clayton Hickey</description><language>en-us</language><copyright>Unless otherwise specified, all rights reserved to Clayton Hickey</copyright><webMaster>clayton@claytondoesthings.xyz (Clayton Hickey)</webMaster><docs>https://www.rssboard.org/rss-specification</docs><generator>Custom OCaml</generator><atom:link href=\"https://claytonhickey.me/rss.xml\" rel=\"self\" type=\"application/rss+xml\"/>" ^ Buffer.contents rss_items ^ "</channel></rss>"
);;

write_string_to_file "www/blog/index.html" (
    build_page
        "Blog - Clayton Hickey"
        "Clayton Hickey's blog"
        "blog"
        Blog
        None
        [html_div [("class", PString "experience-container")] [Buffer.contents blog_post_cards]]
);;

add_sitemap_entry "blog" "weekly" "1";;

Sys.mkdir "www/more-nodes" 0o777;;

write_string_to_file "www/more-nodes/index.html" (
    build_page
        "More Nodes - Clayton Hickey"
        "This page is for if the internet dies and AI takes over. If you want more human-controlled nodes (websites/blogs), then this is the page for you."
        "more-nodes"
        MoreNodes
        None
        [read_file_to_string "more-nodes.html"]
);;

add_sitemap_entry "more-nodes" "weekly" "1";;

write_string_to_file "www/sitemap.xml" (
    "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">" ^ Buffer.contents sitemap_entries ^ "</urlset>"
);;

copy_file "common.css" "www/common.css";;
copy_file "favicon.ico" "www/favicon.ico";;
copy_file "nav.js" "www/nav.js";;
copy_file "stuff.js" "www/stuff.js";;
copy_file "cardViewer.js" "www/cardViewer.js";;
copy_file "mastodonComments.js" "www/mastodonComments.js";;

copy_fs "images" "www/images";;
copy_fs "videos" "www/videos";;
copy_fs "scripts" "www/scripts";;
