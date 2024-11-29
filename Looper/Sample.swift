//
//  Sample.swift
//  Looper
//
//  Created by Kirk Elliott on 11/28/24.
//


import Foundation

struct Sample: Identifiable {
    let id: Int
    let artist: String
    let title: String
    let key: Int
    let bpm: Double
    let fileName: String
}

let sample1 = Sample(id: 1, artist: "Ying Yang Twins", title: "I Yi Yi", key: 2, bpm: 94, fileName: "00000001-body")
let sample2 = Sample(id: 4, artist: "Snoop Dogg", title: "What's My Name", key: 10, bpm: 94, fileName: "00000004-body")
let sample3 = Sample(id: 123, artist: "Too Short", title: "Shake That Monkey", key: 8, bpm: 102, fileName: "00000123-body")

let samples: [Sample] = [
    // BPM 94
    Sample(id: 1, artist: "Ying Yang Twins", title: "I Yi Yi", key: 2, bpm: 94, fileName: "00000001-body"),
    Sample(id: 2, artist: "2Pac", title: "How Do U Want It", key: 2, bpm: 94, fileName: "00000002-body"),
    Sample(id: 3, artist: "Too Short", title: "Couldn't Be a Better Player", key: 2, bpm: 94, fileName: "00000003-body"),
    Sample(id: 4, artist: "Snoop Dogg", title: "What's My Name", key: 10, bpm: 94, fileName: "00000004-body"),
    Sample(id: 5, artist: "Notorious BIG", title: "Hypnotize", key: 9, bpm: 94, fileName: "00000005-body"),
    Sample(id: 6, artist: "Nas", title: "If I Ruled the World", key: 2, bpm: 94, fileName: "00000006-body"),
    Sample(id: 7, artist: "Mobb Deep", title: "Shook Ones Part 2", key: 3, bpm: 94, fileName: "00000007-body"),
    Sample(id: 8, artist: "Ludacris", title: "Southern Hospitality", key: 10, bpm: 94, fileName: "00000008-body"),
    Sample(id: 9, artist: "Lil Wayne", title: "Shine", key: 6, bpm: 94, fileName: "00000009-body"),
    Sample(id: 10, artist: "Kane and Abel", title: "Show Dat Work", key: 8, bpm: 94, fileName: "00000010-body"),
    Sample(id: 11, artist: "Juvenile", title: "Back That Azz Up", key: 7, bpm: 94, fileName: "00000011-body"),
    Sample(id: 12, artist: "J-Kwon", title: "Tipsy", key: 4, bpm: 94, fileName: "00000012-body"),
    Sample(id: 13, artist: "Dr Dre", title: "The Next Episode", key: 2, bpm: 94, fileName: "00000013-body"),
    Sample(id: 14, artist: "David Banner", title: "Play", key: 5, bpm: 94, fileName: "00000014-body"),
    Sample(id: 15, artist: "Clipse", title: "Grindin'", key: 4, bpm: 94, fileName: "00000015-body"),
    Sample(id: 16, artist: "Ali", title: "Breathe In, Breathe Out", key: 8, bpm: 94, fileName: "00000016-body"),
    Sample(id: 18, artist: "Boo & Gotti", title: "Ain't It Man", key: 4, bpm: 94, fileName: "00000018-body"),
    Sample(id: 19, artist: "T.I.", title: "Why U Wanna", key: 8, bpm: 94, fileName: "00000019-body"),
    Sample(id: 20, artist: "50 Cent", title: "In Da Club", key: 6, bpm: 94, fileName: "00000020-body"),
    Sample(id: 21, artist: "Beyoncé", title: "Single Ladies", key: 4, bpm: 94, fileName: "00000021-body"),
    Sample(id: 22, artist: "50 Cent", title: "I Get It In", key: 12, bpm: 94, fileName: "00000022-body"),
    Sample(id: 24, artist: "Lil Mo", title: "Superwoman Remix", key: 12, bpm: 94, fileName: "00000024-body"),
    Sample(id: 25, artist: "Fabolous", title: "Can't Deny It", key: 4, bpm: 94, fileName: "00000025-body"),
    Sample(id: 26, artist: "Masta Ace", title: "Born to Roll", key: 4, bpm: 94, fileName: "00000026-body"),
    Sample(id: 30, artist: "Snoop Dogg", title: "Deep Cover", key: 4, bpm: 94, fileName: "00000030-body"),
    Sample(id: 31, artist: "Snoop Dogg", title: "Drop It Like It's Hot", key: 9, bpm: 94, fileName: "00000031-body"),
    Sample(id: 32, artist: "Dr Dre", title: "Dre Day", key: 1, bpm: 94, fileName: "00000032-body"),
    Sample(id: 34, artist: "Juvenile", title: "Ha", key: 5, bpm: 94, fileName: "00000034-body"),
    Sample(id: 35, artist: "Silk the Shocker", title: "Ain't My Fault Part 2", key: 4, bpm: 94, fileName: "00000035-body"),
    Sample(id: 36, artist: "Nas", title: "Street Dreams", key: 6, bpm: 94, fileName: "00000036-body"),
    Sample(id: 37, artist: "Lil Wayne", title: "I Need a Hot Girl", key: 6, bpm: 94, fileName: "00000037-body"),
    Sample(id: 38, artist: "Paul Cameron", title: "Brown Beat", key: 8, bpm: 94, fileName: "00000038-body"),
    Sample(id: 40, artist: "Sean Paul", title: "Baby Boy", key: 12, bpm: 94, fileName: "00000040-body"),
    Sample(id: 41, artist: "Pastor Troy", title: "Are We Cuttin", key: 8, bpm: 94, fileName: "00000041-body"),
    Sample(id: 42, artist: "M.O.P.", title: "Ante Up", key: 4, bpm: 94, fileName: "00000042-body"),
    Sample(id: 43, artist: "Total", title: "What About Us Remix", key: 3, bpm: 94, fileName: "00000043-body"),
    Sample(id: 44, artist: "Nelly", title: "Shake Ya Tailfeather", key: 11, bpm: 94, fileName: "00000044-body"),
    Sample(id: 45, artist: "Too Short", title: "Quit Hatin'", key: 12, bpm: 94, fileName: "00000045-body"),
    Sample(id: 47, artist: "Mystikal", title: "Been So Long", key: 11, bpm: 94, fileName: "00000047-body"),
    Sample(id: 49, artist: "Chingy", title: "Right Thurr", key: 2, bpm: 94, fileName: "00000049-body"),
    Sample(id: 50, artist: "Chris Brown", title: "Wall 2 Wall", key: 4, bpm: 94, fileName: "00000050-body"),
    Sample(id: 51, artist: "Young Buck", title: "Shorty Wanna Ride", key: 4, bpm: 94, fileName: "00000051-body"),
    Sample(id: 52, artist: "Juvenile", title: "In My Life", key: 9, bpm: 94, fileName: "00000052-body"),
    Sample(id: 54, artist: "Juvenile", title: "From Her Mama", key: 6, bpm: 94, fileName: "00000054-body"),
    Sample(id: 55, artist: "Big Tymers", title: "Number One Stunna", key: 1, bpm: 94, fileName: "00000055-body"),
    Sample(id: 56, artist: "Big Tymers", title: "Get Your Roll On", key: 1, bpm: 94, fileName: "00000056-body"),
    Sample(id: 57, artist: "LL Cool J", title: "Doin' It", key: 4, bpm: 94, fileName: "00000057-body"),
    Sample(id: 58, artist: "Jim Jones", title: "We Fly High", key: 1, bpm: 94, fileName: "00000058-body"),
    Sample(id: 59, artist: "Kia Shine", title: "Krispy", key: 8, bpm: 94, fileName: "00000059-body"),
    Sample(id: 60, artist: "Vockah Redu", title: "Roll Call", key: 10, bpm: 94, fileName: "00000060-body"),
    Sample(id: 61, artist: "Quint Black", title: "Shake Dem Haters Off", key: 12, bpm: 94, fileName: "00000061-body"),
    
    // BPM 84
    Sample(id: 62, artist: "Traxster", title: "Freak Hoes", key: 2, bpm: 84, fileName: "00000062-body"),
    Sample(id: 63, artist: "Lil Wayne", title: "Bring It Back", key: 6, bpm: 84, fileName: "00000063-body"),
    Sample(id: 64, artist: "YoungBloodZ", title: "Presidential", key: 6, bpm: 84, fileName: "00000064-body"),
    Sample(id: 65, artist: "Lil Wayne", title: "Go DJ", key: 1, bpm: 84, fileName: "00000065-body"),
    Sample(id: 66, artist: "Total", title: "What About Us Remix", key: 1, bpm: 84, fileName: "00000066-body"),
    Sample(id: 68, artist: "Jay-Z", title: "Dirt Off Your Shoulder", key: 3, bpm: 84, fileName: "00000068-body"),
    Sample(id: 69, artist: "Lil Boosie", title: "Wipe Me Down Remix", key: 4, bpm: 84, fileName: "00000069-body"),
    Sample(id: 70, artist: "Snoop Dogg", title: "Woof", key: 11, bpm: 84, fileName: "00000070-body"),
    Sample(id: 71, artist: "Too Short", title: "Quit Hatin'", key: 5, bpm: 84, fileName: "00000071-body"),
    Sample(id: 72, artist: "Kelis", title: "Bossy", key: 2, bpm: 84, fileName: "00000072-body"),
    Sample(id: 73, artist: "Chris Brown", title: "Get Like Me", key: 1, bpm: 84, fileName: "00000073-body"),
    Sample(id: 74, artist: "Ludacris", title: "Get Back", key: 3, bpm: 84, fileName: "00000074-body"),
    Sample(id: 75, artist: "Lil Wayne", title: "Stuntin' Like My Daddy", key: 11, bpm: 84, fileName: "00000075-body"),
    Sample(id: 76, artist: "Super Duck Breaks", title: "Beak This", key: 10, bpm: 84, fileName: "00000076-body"),
    Sample(id: 77, artist: "Trillville", title: "Some Cut", key: 9, bpm: 84, fileName: "00000077-body"),
    Sample(id: 78, artist: "Nelly", title: "E.I.", key: 1, bpm: 84, fileName: "00000078-body"),
    Sample(id: 79, artist: "504 Boyz", title: "Wobble Wobble", key: 1, bpm: 84, fileName: "00000079-body"),
    Sample(id: 80, artist: "T.I.", title: "Big Things Poppin'", key: 5, bpm: 84, fileName: "00000080-body"),
    Sample(id: 81, artist: "P$C", title: "I'm a King", key: 4, bpm: 84, fileName: "00000081-body"),
    Sample(id: 82, artist: "Juvenile", title: "Set It Off", key: 4, bpm: 84, fileName: "00000082-body"),
    Sample(id: 83, artist: "T.I.", title: "24's", key: 11, bpm: 84, fileName: "00000083-body"),
    Sample(id: 84, artist: "54th Platoon", title: "Holdin' It Down", key: 12, bpm: 84, fileName: "00000084-body"),
    Sample(id: 85, artist: "Lil Scrappy", title: "No Problem", key: 5, bpm: 84, fileName: "00000085-body"),
    Sample(id: 90, artist: "Usher", title: "You Make Me Wanna Remix", key: 5, bpm: 84, fileName: "00000090-body"),
    Sample(id: 91, artist: "Three 6 Mafia", title: "You Scared Part 2", key: 1, bpm: 84, fileName: "00000091-body"),
    Sample(id: 92, artist: "Nelly", title: "Country Grammar", key: 6, bpm: 84, fileName: "00000092-body"),
    Sample(id: 94, artist: "T.I.", title: "Top Back", key: 1, bpm: 84, fileName: "00000094-body"),
    Sample(id: 95, artist: "David Banner", title: "Shawty Say", key: 6, bpm: 84, fileName: "00000095-body"),
    Sample(id: 96, artist: "Lil Keke", title: "Southside", key: 12, bpm: 84, fileName: "00000096-body"),
    Sample(id: 97, artist: "Kingpin Skinny Pimp", title: "TV's Remix", key: 9, bpm: 84, fileName: "00000097-body"),
    Sample(id: 99, artist: "Three 6 Mafia", title: "Who Run It", key: 6, bpm: 84, fileName: "00000099-body"),
    Sample(id: 100, artist: "Jay-Z", title: "Hey Papi", key: 12, bpm: 84, fileName: "00000100-body"),
    Sample(id: 103, artist: "YoungBloodZ", title: "Datz Me", key: 6, bpm: 84, fileName: "00000103-body"),
    Sample(id: 105, artist: "E-40", title: "Rep Yo City", key: 1, bpm: 84, fileName: "00000105-body"),
    Sample(id: 106, artist: "Lil Jon", title: "I Don't Give a What", key: 8, bpm: 84, fileName: "00000106-body"),
    Sample(id: 107, artist: "Rich Boy", title: "Throw Some D's", key: 4, bpm: 84, fileName: "00000107-body"),
    Sample(id: 109, artist: "Juvenile", title: "Nolia Clap", key: 2, bpm: 84, fileName: "00000109-body"),
    Sample(id: 110, artist: "Lil Wayne", title: "Fireman", key: 6, bpm: 84, fileName: "00000110-body"),
    Sample(id: 111, artist: "Yung Joc", title: "It's Goin' Down", key: 1, bpm: 84, fileName: "00000111-body"),
    Sample(id: 112, artist: "Ludacris", title: "Stand Up", key: 9, bpm: 102, fileName: "00000112-body"),
    Sample(id: 113, artist: "Magic", title: "I Smoke, I Drank Remix", key: 9, bpm: 84, fileName: "00000113-body"),
    Sample(id: 115, artist: "Nelly", title: "Air Force Ones", key: 10, bpm: 84, fileName: "00000115-body"),
    Sample(id: 116, artist: "Lil Jon", title: "Snap Yo Fingers", key: 1, bpm: 84, fileName: "00000116-body"),
    Sample(id: 117, artist: "Nelly", title: "Grillz", key: 11, bpm: 84, fileName: "00000117-body"),
    Sample(id: 118, artist: "Cam'Ron", title: "Down and Out", key: 4, bpm: 84, fileName: "00000118-body"),
    Sample(id: 119, artist: "Busta Rhymes", title: "Break Ya Neck", key: 8, bpm: 84, fileName: "00000119-body"),
    Sample(id: 121, artist: "Three 6 Mafia", title: "Ridin Spinners", key: 8, bpm: 84, fileName: "00000121-body"),
    
    // BPM 102
    Sample(id: 123, artist: "Too Short", title: "Shake That Monkey", key: 8, bpm: 102, fileName: "00000123-body"),
    Sample(id: 124, artist: "Juelz Santana", title: "There It Go", key: 6, bpm: 102, fileName: "00000124-body"),
    Sample(id: 125, artist: "LL Cool J", title: "Headsprung", key: 1, bpm: 102, fileName: "00000125-body"),
    Sample(id: 126, artist: "Sean Paul", title: "Get Busy", key: 2, bpm: 102, fileName: "00000126-body"),
    Sample(id: 127, artist: "Choppa", title: "Choppa Style", key: 2, bpm: 102, fileName: "00000127-body"),
    Sample(id: 128, artist: "Master P", title: "Rock It", key: 1, bpm: 102, fileName: "00000128-body"),
    Sample(id: 129, artist: "Too Short", title: "Blow the Whistle", key: 5, bpm: 102, fileName: "00000129-body"),
    Sample(id: 130, artist: "Too Short", title: "Burn Rubber", key: 5, bpm: 102, fileName: "00000130-body"),
    Sample(id: 131, artist: "Lil Jon", title: "Get Low", key: 5, bpm: 102, fileName: "00000131-body"),
    Sample(id: 132, artist: "Master P", title: "Them Jeans", key: 5, bpm: 102, fileName: "00000132-body"),
    Sample(id: 134, artist: "Loon", title: "How U Want That", key: 1, bpm: 102, fileName: "00000134-body"),
    Sample(id: 135, artist: "Khia", title: "My Neck, My Back", key: 8, bpm: 102, fileName: "00000135-body"),
    Sample(id: 136, artist: "Ying Yang Twins", title: "Salt Shaker", key: 2, bpm: 102, fileName: "00000136-body"),
    Sample(id: 137, artist: "Usher", title: "Yeah", key: 6, bpm: 102, fileName: "00000137-body"),
    Sample(id: 138, artist: "T.I.", title: "I'm Serious Remix", key: 9, bpm: 102, fileName: "00000138-body"),
    Sample(id: 140, artist: "Missy Elliott", title: "Work It", key: 5, bpm: 102, fileName: "00000140-body"),
    Sample(id: 141, artist: "E-40", title: "Tell Me When To Go", key: 9, bpm: 102, fileName: "00000141-body"),
    Sample(id: 143, artist: "Young Gunz", title: "Can't Stop Won't Stop", key: 1, bpm: 102, fileName: "00000143-body"),
    Sample(id: 144, artist: "Petey Pablo", title: "Freek a Leek", key: 1, bpm: 102, fileName: "00000144-body"),
    Sample(id: 145, artist: "Ludacris", title: "Stand Up", key: 3, bpm: 102, fileName: "00000145-body"),
    Sample(id: 147, artist: "Jay-Z", title: "Just Wanna Luv U", key: 4, bpm: 102, fileName: "00000147-body"),
    Sample(id: 148, artist: "Silky Slim", title: "Sista Sista", key: 6, bpm: 102, fileName: "00000148-body"),
    Sample(id: 149, artist: "Ludacris", title: "Area Codes", key: 8, bpm: 102, fileName: "00000149-body"),
    Sample(id: 150, artist: "Chris Brown", title: "Run It", key: 2, bpm: 102, fileName: "00000150-body"),
    Sample(id: 151, artist: "Ying Yang Twins", title: "Whistle While You Twerk", key: 2, bpm: 102, fileName: "00000151-body"),
    Sample(id: 152, artist: "5th Ward Weebie", title: "On Da Wall", key: 11, bpm: 102, fileName: "00000152-body"),
    Sample(id: 153, artist: "5th Ward Weebie", title: "Toot It Up", key: 6, bpm: 102, fileName: "00000153-body"),
    Sample(id: 154, artist: "The Pack", title: "Vans", key: 2, bpm: 102, fileName: "00000154-body"),
    Sample(id: 155, artist: "Montell Jordan", title: "This Is How We Do It", key: 4, bpm: 102, fileName: "00000155-body"),
    Sample(id: 156, artist: "Ying Yang Twins", title: "Wait (The Whisper Song)", key: 3, bpm: 102, fileName: "00000156-body"),
]
