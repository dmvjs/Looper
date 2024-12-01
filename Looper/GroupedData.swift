// GroupedData.swift

import Foundation

struct BPMGroup: Identifiable {
    let id: Double // BPM value
    let keyGroups: [KeyGroup]
}

struct KeyGroup: Identifiable {
    let id: Int // Key value
    let samples: [Sample]
}

// Mock KeyGroups
let keyGroup1 = KeyGroup(
    id: 1, // Key 1
    samples: [sample1]
)

let keyGroup2 = KeyGroup(
    id: 4, // Key 2
    samples: [sample2]
)

let keyGroup3 = KeyGroup(
    id: 123, // Key 3
    samples: [sample3]
)

let bpmGroup1 = BPMGroup(
    id: 84.0, // BPM 80
    keyGroups: [keyGroup1, keyGroup2]
)

let bpmGroup2 = BPMGroup(
    id: 102.0, // BPM 100
    keyGroups: [keyGroup3]
)
