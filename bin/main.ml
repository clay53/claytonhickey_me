open Soup

let extract_language lang html =
    let soup = parse html in
    let rec helper (node: general node) : general node option =
        begin match Option.map (fun n -> (n, Soup.name n)) (Soup.element node) with
            | Some (node, "ml-s") ->
                let pulled = ref None in
                Soup.iter (fun pullable -> (
                    begin match Soup.attribute "lang" pullable with
                        | Some langAttr ->
                            if String.equal langAttr lang then
                                pulled := Some pullable
                            else begin match !pulled with
                                | None -> pulled := Some pullable
                                | Some _ -> ()
                            end
                        | None -> ()
                    end
                )) (Soup.elements (Soup.children node));
                begin match !pulled with
                    | Some pulled -> pulled |> Soup.children |> Soup.filter_map helper |> (Soup.clear pulled; Soup.iter (Soup.append_child pulled)); Some (Soup.coerce pulled)
                    | None -> None
                end
            | Some (node, _) -> Soup.children node |> Soup.filter_map helper |> (Soup.clear node; Soup.iter (Soup.append_child node)); Some (Soup.coerce node)
            | None -> Some node
        end
    in
    soup |> Soup.children |> Soup.filter_map helper |> (Soup.clear soup; Soup.iter (Soup.append_root soup));
    soup |> Soup.to_string
;;

let extract_en = extract_language "en";;

let remove_html html =
    let soup = parse html in
    String.concat "" (Soup.texts soup)
;;

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
    "<ml-s><span lang=\"en\">Switch Language</span><span lang=\"ja\">言語を変える</span></ml-s>: ";
    "<button onclick=\"setPreferredLang('en')\">English</button><button onclick=\"setPreferredLang('ja')\">日本語</button>";
    "<br>";
    "<ml-s><span lang=\"en\">Check out the code on </span><span lang=\"ja\">コードを見る：</span></ml-s>";
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
    | Games
;;

let build_page title description canonical_path nav_type og_image_path content =
    let bare_title = title |> extract_en |> remove_html in
    "<!DOCTYPE html>"
    ^ html_element_string "html" [] (List ([], true))
    ^ html_element_string "head" [] (List ([
        html_element_string "meta" [("charset", PString "UTF-8")] SelfClosing;
        html_element_string "title" [] (List ([bare_title], false));
        meta_string "description" description;
        meta_link_string "canonical" None ("https://claytonhickey.me/" ^ canonical_path);
        meta_string "viewport" "width=device-width, initial-scale=1";
        meta_link_string "stylesheet" (Some "text/css") "/common.css";
        meta_link_string "icon" (Some "image/ico") "/favicon.ico";
        meta_og ["title"] bare_title;
        meta_og ["type"] "website";
        meta_og ["description"] description;
        meta_og ["url"] ("https://claytonhickey.me/" ^ canonical_path);
        meta_og ["image"] begin match og_image_path with
            | None -> "https://claytonhickey.me/images/headshot.jpg"
            | Some path -> "https://claytonhickey.me/" ^ path
        end;
        meta_string "twitter:card" "summary_large_image";
        meta_string "twitter:site" "@ClaytonsThings";
        meta_string "twitter:title" bare_title;
        meta_string "twitter:description" description;
        meta_string "twitter:image" begin match og_image_path with
            | None -> "https://claytonhickey.me/images/headshot.jpg"
            | Some path -> "https://claytonhickey.me/" ^ path
        end;
        html_element_string "link" [("rel", PString "alternate"); ("type", PString "application/rss+xml"); ("title", PString "Clayton Hickey's Blog"); ("href", PString "/rss.xml")] SelfClosing;
        script_import_string "/scripts/nav.js";
        html_element_string "script" [("src", PString "/scripts/multilingual.js"); ("defer", PBool(true))] (List ([], false));
    ], false))
    ^ html_element_string "body" [] (List ([
        html_div [("id", PString "htmlTitle"); ("style", PString "display: none;")] [title];
        html_element_string "script" [] (List (["document.title = htmlTitle.innerText; (new MutationObserver(()=>{document.title = htmlTitle.innerText})).observe(htmlTitle, {subtree: true, childList: true, attributes: true, characterData: true});"], false));
        html_element_string "my-nav" [("type", PString begin match nav_type with
            | Home -> "home"
            | Blog -> "blog"
            | MoreNodes -> "more-nodes"
            | Games -> "games"
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
        if Sys.file_exists dest then (
            (Array.iter (fun n -> copy_fs (src ^ "/" ^ n) (dest ^ "/" ^ n))) (Sys.readdir src);
        ) else (
            Sys.mkdir dest 0o777;
            (Array.iter (fun n -> copy_fs (src ^ "/" ^ n) (dest ^ "/" ^ n))) (Sys.readdir src);)
        )
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

copy_fs "copy" "www";;

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
    "<ml-s><span lang=\"en\">Clayton Hickey</span><span lang=\"ja\">クレイトン・ヒッキー</span></ml-s>"
    "Clayton Hickey's Website"
    ""
    Home
    None
    [read_file_to_string "includes/home-body.html"]
);;


add_sitemap_entry "" "weekly" "1";;

let rss_items = Buffer.create 1000;;
let rss_items_ja = Buffer.create 1000;;

let add_rss_item title description canonical_path cover_image_url date html_content enclosures =
    let add_by_lang buffer lang enclosure =
        Buffer.add_string buffer (
            "<item><title>" ^ (title |> extract_language lang |> remove_html) ^ "</title><description>" ^ (description |> extract_language lang |> remove_html) ^ "</description><media:description type=\"plain\">" ^ (description |> extract_language lang |> remove_html) ^ "</media:description><link>https://claytonhickey.me/" ^ canonical_path ^ "</link><guid>https://claytonhickey.me/" ^ canonical_path ^ "</guid><pubDate>" ^ Date.as_rss_date date ^ "</pubDate>" ^ begin match cover_image_url with | Some cover_image_url -> "<itunes:image href=\"" ^ cover_image_url ^ "\"/>" | None -> "" end ^ "<content:encoded><![CDATA[" ^ (html_content |> extract_language lang) ^ "]]></content:encoded>" ^ begin match enclosure with | None -> "" | Some (path, ty, size) -> "<enclosure url=\"https://claytonhickey.me" ^ path ^ "\" length=\"" ^ string_of_int size ^ "\" type=\"" ^ ty ^ "\"/>" end ^ "</item>"
        );
    in
    let (en_enclosure, ja_enclosure) = enclosures in
    add_by_lang rss_items "en" en_enclosure;
    add_by_lang rss_items_ja "ja" ja_enclosure;
;;

Sys.mkdir "www/blog" 0o777
;;

let blog_post_cards = Buffer.create 1000;;

let add_blog_post_card title description canonical_path pub_date edit_date thumb_path thumb_alt =
    Buffer.add_string blog_post_cards (html_div [("class", PString "experience")] [
        html_header 3 [
            html_div [("class", PString "experience-title-links")] [
                html_element_string "a" [("class", PString "experience-title"); ("href", PString ("/" ^ canonical_path))] (List ([title], false));
                html_a ("/" ^ canonical_path) false ["<ml-s><span lang=\"en\">Read</span><span lang=\"ja\">読む</span></ml-s>"]
            ]
        ];
        html_a ("/" ^ canonical_path ^ "/") false [html_img ("/" ^ thumb_path) thumb_alt [("class", PString "experience-img")]];
        html_p (("<ml-s><span lang=\"en\">Published: </span><span lang=\"ja\">著した日付：</span></ml-s>" ^ Date.as_rss_date pub_date) :: begin match edit_date with | None -> [] | Some d -> ["<br>Edited: " ^ Date.as_rss_date d] end);
        html_p [description];
    ]);
;;

let urlencode s =
    let helper (rules:(char*string) list) (i:string) =
        let char_to_escaped (c: char) =
            let rec char_to_escaped_helper (unchecked_rules: (char*string) list) =
                begin match unchecked_rules with
                    | (m, r) :: t -> if m=c then r else char_to_escaped_helper t
                    | [] -> String.make 1 c
                end
            in
            char_to_escaped_helper rules
        in
        String.fold_left (fun a c -> String.cat a (char_to_escaped c)) "" i
    in
    helper [('/', "%2F")] s
;;
            

let add_blog_post_raw title description html_content rss_content canonical_path date edit_date thumb_path thumb_alt assets mastodon_thread voiceovers =
    let fs_path = "www/" ^ canonical_path in
    Sys.mkdir fs_path 0o777;
    let no_html_en_title = title |> extract_en |> remove_html in
    let no_html_en_description = description |> extract_en |> remove_html in
    let full_html = build_page
        (title ^ " - <ml-s><span lang=\"en\">Clayton Hickey</span><span lang=\"ja\">クレイトン・ヒッキー</span></ml-s>")
        no_html_en_description
        (canonical_path ^ "/")
        Blog
        (Some thumb_path)
        [
            html_element_string "ml-s" [] (let (en, ja) = voiceovers in List ([
                
                begin match en with
                    | None -> ""
                    | Some (path, ty, _size) -> html_element_string "p" [("lang", PString "en")] (List ([
                        "voiceover: ";
                        html_element_string "audio" [("controls", PBool true)] (List ([
                            html_element_string "source" [("src", PString path); ("type", PString ty)] SelfClosing
                        ], false))
                    ], false))
                end;
                begin match ja with
                    | None -> ""
                    | Some (path, ty, _size) -> html_element_string "p" [("lang", PString "ja")] (List ([
                        "オーディオ：";
                        html_element_string "audio" [("controls", PBool true)] (List ([
                            html_element_string "source" [("src", PString path); ("type", PString ty)] SelfClosing
                        ], false))
                    ], false))
                end;
            ], false));
            html_content;
            html_p ["<ml-s><span lang=\"en\">Title: </span><span lang=\"ja\">題名：</span></ml-s>" ^ title ^ "<br><ml-s><span lang=\"en\">Authors: </span><span lang=\"ja\">作家・</span></ml-s>Clayton Lopez Hickey<br><ml-s><span lang=\"en\">Published: </span><span lang=\"ja\">著した日付：</span></ml-s>" ^ Date.as_rss_date date ^ begin match edit_date with | Some edit_date -> "<br>Last updated: " ^ Date.as_rss_date edit_date | None -> "" end];
            html_div [] [
                "<script>document.addEventListener(\"DOMContentLoaded\", () => {let d = new Date(); MLAAccessedPosition.innerHTML += ` Accessed ${d.getDay()} ${['Jan.', 'Feb.', 'Mar.', 'Apr.', 'May', 'Jun.', 'Jul.', 'Aug.', 'Sep.', 'Oct.', 'Nov.', 'Dec.'][d.getMonth()]} ${d.getFullYear()}.`;})</script>";
                let href = "https://claytonhickey.me/" ^ (canonical_path ^ "/") in
                html_element_string "p" [("id", PString "mlaCitation")] (List (["<ml-s><span lang=\"en\">MLA Citation:</span><span lang=\"ja\">MLA引用：</span></ml-s><br>" ^ "Hickey, C. L. (" ^ string_of_int (Date.year date) ^ ", " ^ Date.en_month_from_int (Date.month date) ^ " " ^ string_of_int (Date.day date) ^ "). <i>" ^ title ^ "</i>. Clayton Hickey. " ^ html_a href false [href] ^ ".<span id=\"MLAAccessedPosition\"></span>"], false));
            ];
            html_header 2 [
                "<ml-s><span lang=\"en\">Like this post? </span><span lang=\"ja\">このポストが好き？</span></ml-s>";
                html_a "https://claytonhickey.me/rss.xml" true ["<ml-s><span lang=\"en\">Follow with RSS</span><span lang=\"ja\">RSSでフォローする</span></ml-s>"];
            ];
            html_header 2 [
                "<ml-s><span lang=\"en\">What others are saying on: </span><span lang=\"ja\">他の会話があるサイト：</span></ml-s>";
                html_a ("https://twitter.com/search?q=url%3Aclaytonhickey.me%2F" ^ urlencode canonical_path) true ["𝕏"];
                ", ";
                html_a ("https://google.com/search?q=%22claytonhickey.me%2F" ^ urlencode canonical_path ^ "%22") true ["Google"];
                ", ";
                html_a ("https://reddit.com/search?q=url%3Aclaytonhickey.me%2F" ^ urlencode canonical_path) true ["Reddit"];
            ];
            html_header 2 [
                "<ml-s><span lang=\"en\">Comment on: </span><span lang=\"ja\">返事のサイト：</span></ml-s>";
                html_a ("https://twitter.com/intent/tweet?text=%0A%0A@ClaytonsThings claytonhickey.me%2F" ^ urlencode canonical_path) true ["𝕏"];
                ", ";
                html_a ("https://www.reddit.com/submit?url=https%3A%2F%2Fclaytonhickey.me%2F" ^ urlencode canonical_path ^ "&title=" ^ urlencode no_html_en_title) true ["Reddit"];
                ", ";
                html_a ("https://www.facebook.com/sharer.php?u=https%3A%2F%2Fclaytonhickey.me%2F" ^ urlencode canonical_path) true ["Facebook"];
            ];
            html_header 2 [
                "<ml-s><span lang=\"en\">Comment to me directly: </span><span lang=\"ja\">メールで返事する：</span></ml-s>";
                html_a ("mailto:clayton@claytondoesthings.xyz?subject=<short> - comment on https:%2F%2Fclaytonhickey.me%2F" ^ urlencode canonical_path ^ "&body=Hey Clayton,%0A%0A%0A%0ASigned,%0A<your name>") false ["clayton@claytondoesthings.xyz"];
            ];
            begin match mastodon_thread with
                | None -> ""
                | Some thread_url -> raise (Failure ("maston disabled " ^ canonical_path))
            end;
        ]
    in
    write_string_to_file
        (fs_path ^ "/index.html") 
        full_html
    ;
    List.iter (fun (n, b) -> write_bytes_to_file (fs_path ^ "/" ^ n) b) assets;
    add_rss_item title description (canonical_path ^ "/") (Some ("https://claytonhickey.me/" ^ thumb_path)) date ("<p><ml-s><span lang=\"en\">Read directly: </span><span lang=\"ja\">ここで読んでください</span></ml-s><a href=\"https://claytonhickey.me/" ^ canonical_path ^ "/\">https://claytonhickey.me/" ^ canonical_path ^ "/</a></p>" ^ rss_content) voiceovers;
    add_blog_post_card title description canonical_path date edit_date thumb_path thumb_alt;
    add_sitemap_entry (canonical_path ^ "/") "yearly" "0.9";
;;

let add_blog_post title description html_content rss_content folder_name date edit_date thumb_path thumb_alt assets mastodon_thread voiceovers = add_blog_post_raw
    title
    description
    html_content
    rss_content
    ("blog/" ^ folder_name)
    date
    edit_date
    thumb_path
    thumb_alt
    assets
    mastodon_thread
    voiceovers
;;

let add_blog_post_from_folder title description date folder_name thumb_path thumb_alt mastodon_thread =
    let html = read_file_to_string ("includes/blogs-v0/" ^ folder_name ^ "/index.html") in
    let asset_filenames = List.filter (fun f -> not (String.equal f "index.html")) (Array.to_list (Sys.readdir ("includes/blogs-v0/" ^ folder_name))) in
    let assets = List.map
        (fun n -> (n, read_file_to_bytes ("includes/blogs-v0/" ^ folder_name ^ "/" ^ n)))
        asset_filenames
    in
    add_blog_post title description html html folder_name date None thumb_path thumb_alt assets mastodon_thread (None, None)
;;

let add_blog_post_from_folder_thumb_contained title description date folder_name thumb_filename thumb_alt mastodon_thread = add_blog_post_from_folder title description date folder_name ("blog/" ^ folder_name ^ "/" ^ thumb_filename) thumb_alt mastodon_thread;;

let file_size filename =
    let ic = open_in_bin filename in  
    let () = seek_in ic 0 in
    seek_in ic 0;
    let size = in_channel_length ic in
    close_in ic; 
    size
;;

let parsed_obsidian_posts = List.stable_sort
    (fun a b ->
        let (_, _, _, _, _, _, _, _, _, date1, _, _) = a in
        let (_, _, _, _, _, _, _, _, _, date2, _, _) = b in
        -(Date.compare date1 date2)
    )
    (List.map (fun n ->
        let ic = open_in ("includes/blogs-v1/" ^ n ^ "/index.html") in
        let title = Option.get (In_channel.input_line ic) in
        let description = Option.get (In_channel.input_line ic) in
        let thumb_path = Option.get (In_channel.input_line ic) in
        let thumb_alt = Option.get (In_channel.input_line ic) in
        let date_string = In_channel.input_line ic in
        let pub_date =
            begin match date_string with
                | None -> failwith ("missing pub date string in " ^ n)
                | Some s ->
                    begin match String.split_on_char '-' s with
                        | [year; month; day; hour; minute; second] ->
                            Date.new_date_et (int_of_string year) (int_of_string month) (int_of_string day) (int_of_string hour) (int_of_string minute) (int_of_string second)
                        | _ -> failwith ("malformed date on " ^ n)
                    end
            end
        in
        let edit_date_string = Option.get (In_channel.input_line ic) in
        let edit_date =
            if String.length edit_date_string = 0 then None else
                begin match String.split_on_char '-' edit_date_string with
                    | [year; month; day; hour; minute; second] ->
                        Some (Date.new_date_et (int_of_string year) (int_of_string month) (int_of_string day) (int_of_string hour) (int_of_string minute) (int_of_string second))
                    | _ -> failwith ("malformed date on " ^ n)
                end
        in
        let mastodon_thread_string = Option.get (In_channel.input_line ic) in
        let mastodon_thread = if String.length mastodon_thread_string = 0 then None else Some mastodon_thread_string in
        let html = In_channel.input_all ic in
        let assets = List.map
            (fun n2 -> (n2, read_file_to_bytes ("includes/blogs-v1/" ^ n ^ "/" ^ n2)))
            (List.filter (fun n2 -> not (String.equal n2 "index.html")) (Array.to_list (Sys.readdir ("includes/blogs-v1/" ^ n))))
        in
        let en_voiceover = if Sys.file_exists ("includes/blogs-v1/" ^ n ^ "/voiceover.mp3") then (Some (("/blog/" ^ n ^ "/voiceover.mp3"), "audio/mpeg", file_size ("includes/blogs-v1/" ^ n ^ "/voiceover.mp3"))) else None in
        let ja_voiceover = if Sys.file_exists ("includes/blogs-v1/" ^ n ^ "/voiceover.ja.mp3") then (Some (("/blog/" ^ n ^ "/voiceover.ja.mp3"), "audio/mpeg", file_size ("includes/blogs-v1/" ^ n ^ "/voiceover.ja.mp3"))) else None in
        let voiceovers = (en_voiceover, ja_voiceover) in
        (title, description, n, thumb_path, thumb_alt, mastodon_thread, html, html, assets, pub_date, edit_date, voiceovers)
    ) (Array.to_list (Sys.readdir "includes/blogs-v1")))
;;

List.iter (fun (title, description, folder_name, thumb_path, thumb_alt, mastodon_thread, html_content, rss_content, assets, pub_date, edit_date, voiceovers) -> add_blog_post
    title
    description
    html_content
    rss_content
    folder_name
    pub_date
    edit_date
    thumb_path
    thumb_alt
    assets
    mastodon_thread
    voiceovers
) parsed_obsidian_posts;;

add_blog_post_from_folder_thumb_contained "My User-Control-Focused Stack" "How I use various systems like RSS, Mastodon/Activity Pub, Linode, Nextcloud, and Nix to increase my computational independence." (Date.new_date_et 2024 2 11 0 32 0) "my-user-control-focused-stack" "thumb.png" "Various logos including RSS, Mastodon, Nextcloud, Linode, Nix, Vaultwarden" (None);;

add_blog_post_from_folder "My first semester as a UPenn student" "A description of my semester year as a student at the University of Pennsylvania (UPenn)" (Date.new_date_et 2023 12 29 3 30 0) "my-first-semester-as-a-upenn-student" "images/misc/dubois_college_house.jpg" "W.E.B. Dubois College House" (None);;

add_blog_post_from_folder_thumb_contained "How Should Bail Algorithms Be Used" "Should bail algorithms be used today or in the future? Here's my stance. Written for Tech Roulette 2021, P4M3 - Justice Matrix" (Date.new_date_et 2021 7 10 0 0 0) "how-should-bail-algorithms-be-used" "judge-handing-computer-an-L.png" "A judge handing a computer an L" (None);;

add_blog_post_from_folder_thumb_contained "A Theoretical Algorithm for Deciding Bail" "A quick look into creating a computer algorithm for deciding bail for someone awaiting trial. Written for Tech Roulette 2021, P4M2 - Justice Matrix" (Date.new_date_et 2021 7 10 0 0 0) "a-theoretical-algorithm-for-deciding-bail" "computer-holding-freedom-random.png" "Your freedom will cost 100 million dollars" (None);;

add_blog_post_from_folder_thumb_contained "Recommendation Algorithms and Ethics" "A not-very-short not-very-source-heavy dive into recommendation algorithms and the ethical questions surrounding them. Written for Tech Roulette 2021, P4M1 - Justice Matrix" (Date.new_date_et 2021 7 9 0 0 0) "recommendation-algorithms-and-ethics" "youtube-handing-viewer-burning-baby.png" "YouTube logo handing viewer a burning baby" (None);;

write_string_to_file "www/blog/index.html" (
    build_page
        "<ml-s><span lang=\"en\">Blog - Clayton Hickey</span><span lang=\"ja\">ブログ - クレイトン・ヒッキー</span></ml-s>"
        "Clayton Hickey's blog"
        "blog/"
        Blog
        None
        [html_div [("class", PString "experience-container")] [Buffer.contents blog_post_cards]]
);;

add_sitemap_entry "blog/" "weekly" "1";;

Sys.mkdir "www/more-nodes" 0o777;;

write_string_to_file "www/more-nodes/index.html" (
    build_page
        "More Nodes - Clayton Hickey"
        "This page is for if the internet dies and AI takes over. If you want more human-controlled nodes (websites/blogs), then this is the page for you."
        "more-nodes/"
        MoreNodes
        None
        [read_file_to_string "includes/more-nodes.html"]
);;

add_sitemap_entry "more-nodes/" "weekly" "1";;

write_string_to_file "www/sitemap.xml" (
    "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">" ^ Buffer.contents sitemap_entries ^ "</urlset>"
);;

Sys.mkdir "www/games" 0o777;;

let games = Array.map (fun game_path ->
    let full_game_path = "includes/games/" ^ game_path in
    let ic = open_in (full_game_path ^ "/index.html") in
    let title = Option.get (In_channel.input_line ic) in
    let author = Option.get (In_channel.input_line ic) in
    let short_description = Option.get (In_channel.input_line ic) in
    let description = In_channel.input_all ic in
    let channels =
        List.map (fun channel_path ->
            let full_channel_path = full_game_path ^ "/channels/" ^ channel_path in
            let ic2 = open_in (full_channel_path ^ "/index.html") in
            let channel_name = Option.get (In_channel.input_line ic2) in
            let releases =
                List.filter_map (fun release_path ->
                    let full_release_path = full_channel_path ^ "/" ^ release_path in
                    if String.equal release_path "index.html" then None else Some (
                        let ic3 = open_in (full_release_path ^ "/index.html") in
                        let web = String.equal (Option.get (In_channel.input_line ic3)) "web" in
                        let index_or_file_name = if web then (In_channel.input_all ic3) else Option.get (In_channel.input_line ic3) in
                        (release_path, web, index_or_file_name)
                    )
                ) (Array.to_list (Sys.readdir ("includes/games/" ^ game_path ^ "/channels/" ^ channel_path)))
            in
            close_in ic2;
            (channel_path, channel_name, releases)
        ) (Array.to_list (Sys.readdir ("includes/games/" ^ game_path ^ "/channels")))
    in
    close_in ic;
    (game_path, title, author, short_description, description, channels)
) (Sys.readdir "includes/games")
;;

Array.iter (fun (game_path, game_title, author, short_description, description, channels) ->
    let src_game_path = "includes/games/" ^ game_path in
    let out_game_path = "www/games/" ^ game_path in
    Sys.mkdir out_game_path 0o777;
    write_string_to_file (out_game_path ^ "/index.html") (
        build_page
            (game_title ^ " - Games - Clayton Hickey")
            short_description
            ("games/" ^ game_path ^ "/")
            Games
            None
            [
                html_header 1 [game_title];
                "By: ";author;
                description;
                html_header 2 ["Release Channels"];
                String.concat "" (List.map (fun (channel_path, channel_name, releases) ->
                    String.concat "" [
                        html_header 3 [channel_name];
                        String.concat "" (List.map (fun (release_path, web, index_or_file_name) ->
                            if web then
                                html_a (channel_path ^ "/" ^ release_path ^ "/") false [release_path]
                            else
                                html_a (channel_path ^ "/" ^ release_path ^ "/" ^ index_or_file_name) false [release_path]
                        ) releases)
                    ]
                ) channels)
            ]
    );
    List.iter (fun (channel_path, channel_name, releases) -> (
        let src_channel_path = src_game_path ^ "/channels/" ^ channel_path in
        let out_channel_path = out_game_path ^ "/" ^ channel_path in
        Sys.mkdir out_channel_path 0o777;
        List.iter (fun (release_path, web, index_or_file_name) ->
            let src_release_path = src_channel_path ^ "/" ^ release_path in
            let out_release_path = out_channel_path ^ "/" ^ release_path in
            if web then (
                copy_fs src_release_path out_release_path;
                Sys.remove (out_release_path ^ "/index.html");
                write_string_to_file (out_release_path ^ "/index.html") index_or_file_name;
            ) else (
                Sys.mkdir out_release_path 0o777;
                copy_file (src_release_path ^ "/" ^ index_or_file_name) (out_release_path ^ "/" ^ index_or_file_name);
            )
        ) releases;
    )) channels;
) games
;;

let write_rss_channel route title description language name items =
    write_string_to_file ("www/" ^ route) ("<?xml version=\"1.0\" encoding=\"UTF-8\"?><rss version=\"2.0\" xmlns:content=\"http://purl.org/rss/1.0/modules/content/\" xmlns:atom=\"http://www.w3.org/2005/Atom\" xmlns:itunes=\"http://www.itunes.com/dtds/podcast-1.0.dtd\" xmlns:media=\"http://search.yahoo.com/mrss/\"><channel><title>" ^ title ^ "</title><link>https://claytonhickey.me/blog</link><description>" ^ description ^ "</description><image><title>" ^ title ^ "</title><url>https://claytonhickey.me/images/headshot.jpg</url><link>https://claytonhickey.me/blog</link></image><language>" ^ language ^ "</language><copyright>Unless otherwise specified, all rights reserved to Clayton Hickey</copyright><managingEditor>clayton@claytondoesthings.xyz (" ^ name ^ ")</managingEditor><webMaster>clayton@claytondoesthings.xyz (" ^ name ^ ")</webMaster><itunes:owner><itunes:name>" ^ name ^ "</itunes:name><itunes:email>clayton@claytondoesthings.xyz</itunes:email></itunes:owner><docs>https://www.rssboard.org/rss-specification</docs><generator>Custom OCaml</generator><atom:link href=\"https://claytonhickey.me/" ^ route ^ "\" rel=\"self\" type=\"application/rss+xml\"/>" ^ items ^ "</channel></rss>")
;;

write_rss_channel "rss.xml" "Clayton Hickey's Blog" "The latest blog posts by Clayton Hickey" "en-us" "Clayton Hickey" (Buffer.contents rss_items);;

write_rss_channel "rss.ja.xml" "クレイトン・ヒッキーのブログ" "クレイトン・ヒッキーの新しいブログのポスト" "ja" "クレイトン・ヒッキー" (Buffer.contents rss_items_ja);;
