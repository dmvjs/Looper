import SwiftUI

/// A subview for each Key group within a BPM group
struct KeyGroupView: View {
    let keyGroup: KeyGroup
    @Binding var sampleVolumes: [Int: Float]
    @ObservedObject var audioManager: AudioManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Key \(keyGroup.id)")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)
            .background(keyColor(keyGroup.id).opacity(0.8))

            ForEach(keyGroup.samples) { sample in
                SampleRecordView(
                    sample: sample,
                    volume: Binding(
                        get: { sampleVolumes[sample.id] ?? 0 },
                        set: { newValue in
                            sampleVolumes[sample.id] = newValue
                            // The actual volume update is handled in onVolumeChange
                        }
                    ),
                    onVolumeChange: { newValue in
                        audioManager.setVolume(for: sample, volume: newValue)
                    }
                )
                .padding(.horizontal)
            }
        }
    }
    
    /// Assigns a color based on the key value.
    private func keyColor(_ key: Int) -> Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .pink, .teal, .cyan, .mint, .gray]
        return colors[(key - 1) % colors.count]
    }
}

struct KeyGroupView_Previews: PreviewProvider {
    static var previews: some View {
        KeyGroupView(
            keyGroup: KeyGroup(id: 1, samples: [Sample(id: 1, artist: "Artist", title: "Title", key: 1, bpm: 100, fileName: "sample")]),
            sampleVolumes: .constant([1: 0.5]),
            audioManager: AudioManager()
        )
    }
}
