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

]
