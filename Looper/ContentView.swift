import SwiftUI

struct ContentView: View {
    @ObservedObject var audioManager = AudioManager.shared
    @State private var sampleVolumes: [Int: Float] = [:]
    @State private var nowPlaying: [Sample] = []

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
                    Spacer().frame(height: 40)
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
                                    .padding(.horizontal, 16) // Add padding to prevent bleed to edge
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
                                            .onTapGesture {
                                                addToNowPlaying(sample: sample)
                                            }
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

                // Now Playing View
                if !nowPlaying.isEmpty {
                    VStack(spacing: 10) {
                        HStack {
                            Text("Now Playing")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal)

                        ForEach(nowPlaying, id: \.id) { sample in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(sample.title)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Text(sample.artist)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                Spacer()
                                Slider(value: Binding(
                                    get: { sampleVolumes[sample.id] ?? 0.5 },
                                    set: { newValue in
                                        sampleVolumes[sample.id] = newValue
                                        audioManager.setVolume(for: sample, volume: newValue)
                                    }
                                ), in: 0...1)
                                    .accentColor(.white)
                                    .frame(width: 100)
                            }
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.9))
                }
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

    private func addToNowPlaying(sample: Sample) {
        if nowPlaying.count < 4 && !nowPlaying.contains(where: { $0.id == sample.id }) {
            nowPlaying.append(sample)
        }
    }
}
