import SwiftUI

struct SampleRecordView: View {
    let sample: Sample
    @Binding var volume: Float
    let onVolumeChange: (Float) -> Void

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "opticaldisc")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)

                VStack(alignment: .leading) {
                    Text(sample.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(sample.artist)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
                Text("\(Int(sample.bpm)) BPM")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.black.opacity(0.6))
            .cornerRadius(10)

            HStack {
                Text("Volume")
                    .foregroundColor(.white)
                Slider(value: Binding(
                    get: { self.volume },
                    set: { newValue in
                        self.volume = newValue
                        self.onVolumeChange(newValue)
                    }
                ), in: 0...1)
            }
            .padding([.leading, .trailing, .bottom])
        }
        .background(Color.black.opacity(0.5))
        .cornerRadius(10)
        .padding(.vertical, 5)
    }
}

struct SampleRecordView_Previews: PreviewProvider {
    static var previews: some View {
        SampleRecordView(
            sample: Sample(id: 1, artist: "Artist", title: "Title", key: 1, bpm: 100, fileName: "00000001-body"),
            volume: .constant(0.5),
            onVolumeChange: { _ in }
        )
    }
}
