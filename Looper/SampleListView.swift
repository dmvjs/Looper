import SwiftUI

/// A subview for the list of samples grouped by BPM and Key
struct SampleListView: View {
    let groupedSamples: [BPMGroup]
    @Binding var sampleVolumes: [Int: Float]
    @ObservedObject var audioManager: AudioManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(groupedSamples) { bpmGroup in
                    VStack(alignment: .leading) {
                        Text("\(Int(bpmGroup.id)) BPM")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        ForEach(bpmGroup.keyGroups) { keyGroup in
                            KeyGroupView(
                                keyGroup: keyGroup,
                                sampleVolumes: $sampleVolumes,
                                audioManager: audioManager
                            )
                        }
                    }
                }
            }
            .padding(.bottom)
        }
    }
}

struct SampleListView_Previews: PreviewProvider {
    static var previews: some View {
        SampleListView(
            groupedSamples: [
                BPMGroup(id: 94, keyGroups: [
                    KeyGroup(id: 2, samples: [Sample(id: 1, artist: "Artist", title: "Title", key: 2, bpm: 94, fileName: "00000001-body")])
                ])
            ],
            sampleVolumes: .constant([1: 0.5]),
            audioManager: AudioManager()
        )
    }
}
