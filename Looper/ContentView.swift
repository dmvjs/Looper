import SwiftUI

struct ContentView: View {
    @ObservedObject var audioManager = AudioManager.shared
    @State private var sampleVolumes: [Int: Float] = [:]

    // Group samples by BPM and Key, sorted by tempo and key
    private var groupedSamples: [(Double, [(Int, [Sample])])] {
        let tempoGroups = Dictionary(grouping: samples) { $0.bpm }.sorted { $0.key < $1.key }
        return tempoGroups.map { (bpm, samples) in
            let keyGroups = Dictionary(grouping: samples) { $0.key }.sorted { $0.key < $1.key }
            return (bpm, keyGroups.map { ($0.key, $0.value) })
        }
    }

    // Define the range of BPMs for the slider based on your samples
    private let minBPM: Double = 60.0
    private let maxBPM: Double = 120.0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Pitch Slider and Tempo Display
                VStack(spacing: 10) {
                    HStack {
                        Text(String(format: "%.1f BPM", audioManager.bpm))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.leading)
                        Spacer()
                        Button(action: {
                            audioManager.pitchLock.toggle()
                        }) {
                            Image(systemName: audioManager.pitchLock ? "lock.fill" : "lock.open")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                        .padding(.trailing)
                    }
                    .padding(.top)

                    // Horizontal Technics 1200 Style Pitch Slider
                    ZStack {
                        // Slider background resembling the Technics slider track
                        Rectangle()
                            .fill(Color.black.opacity(0.8))
                            .frame(height: 40)
                            .overlay(
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(height: 2) // Center line
                            )

                        // Slider with notches
                        Slider(value: $audioManager.bpm, in: minBPM...maxBPM, step: 0.1)
                            .accentColor(.white)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 10)
                }
                .background(Color.black.opacity(0.9))

                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(groupedSamples, id: \.0) { (bpm, keyGroups) in
                            VStack(alignment: .leading) {
                                Text("\(Int(bpm)) BPM")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(.leading)

                                ForEach(keyGroups, id: \.0) { (key, samples) in
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            Text("Key \(key)")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                        .background(keyColor(key).opacity(0.8))

                                        ForEach(samples) { sample in
                                            SampleRecordView(sample: sample, volume: sampleVolumes[sample.id] ?? 0) { newVolume in
                                                sampleVolumes[sample.id] = newVolume
                                                audioManager.setVolume(for: sample, volume: newVolume)
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea(.bottom)
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                audioManager.loadSamples(samples)
                // Initialize volumes
                for sample in samples {
                    sampleVolumes[sample.id] = 0.0
                }
            }
        }
    }

    private func keyColor(_ key: Int) -> Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .pink, .teal, .cyan, .mint, .gray]
        return colors[(key - 1) % colors.count]
    }
}

struct SampleRecordView: View {
    let sample: Sample
    @State var volume: Float
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

