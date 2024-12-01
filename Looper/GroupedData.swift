import Foundation

/// Represents a group of samples sharing the same BPM.
struct BPMGroup: Identifiable {
    let id: Double // BPM value
    let keyGroups: [KeyGroup]
}

/// Represents a group of samples sharing the same Key within a BPM group.
struct KeyGroup: Identifiable {
    let id: Int // Key value
    let samples: [Sample]
}
