import SwiftUI

struct ContentView: View {
    @StateObject var audioManager = AudioManager() // Use @StateObject for proper lifecycle management
    @State private var sampleVolumes: [Int: Float] = [:]
    @State private var showIntro = true

    // Dynamically determine BPM range based on loaded samples
    private var minBPM: Double {
        audioManager.samples.map { $0.bpm }.min() ?? 60.0
    }
    private var maxBPM: Double {
        audioManager.samples.map { $0.bpm }.max() ?? 120.0
    }
    
    var body: some View {
        Group {
            if showIntro {
                BounceIntroView(imageName: "bounce") {
                    showIntro = false
                }
            } else {
                NavigationView {
                    VStack(spacing: 0) {
                        PitchSliderView(bpm: $audioManager.bpm, pitchLock: $audioManager.pitchLock, minBPM: minBPM, maxBPM: maxBPM)
                        
                        SampleListView(groupedSamples: audioManager.groupedSamples, sampleVolumes: $sampleVolumes, audioManager: audioManager)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom))
                            .edgesIgnoringSafeArea(.bottom)
                    }
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        // Option 1: Load samples from predefined array
                        audioManager.loadSamples(samples)
                        
                        // Option 2: Load samples from JSON (Uncomment if using JSON)
                        // audioManager.loadSamplesFromJSON()
                        
                        // Initialize volumes
                        for sample in audioManager.samples {
                            sampleVolumes[sample.id] = 0.0
                        }
                    }
                }
            }
        }
    }
}

/// A subview for the pitch slider and tempo display
struct PitchSliderView: View {
    @Binding var bpm: Double
    @Binding var pitchLock: Bool
    let minBPM: Double
    let maxBPM: Double
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(String(format: "%.1f BPM", bpm))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading)
                Spacer()
                Button(action: {
                    pitchLock.toggle()
                }) {
                    Image(systemName: pitchLock ? "lock.fill" : "lock.open")
                        .foregroundColor(.white)
                        .font(.title)
                }
                .padding(.trailing)
            }
            .padding(.top, 30)

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
                Slider(value: $bpm, in: minBPM...maxBPM, step: 0.1)
                    .accentColor(.white)
                    .padding(.horizontal)
            }
            .padding(.bottom, 10)
        }
        .background(Color.black.opacity(0.9))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
