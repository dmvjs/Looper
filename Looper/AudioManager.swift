import Foundation
import AVFoundation
import Combine

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    private let engine = AVAudioEngine()
    private var players: [Int: AVAudioPlayerNode] = [:]
    private var mixers: [Int: AVAudioMixerNode] = [:]
    private var varispeedNodes: [Int: AVAudioUnitVarispeed] = [:]
    private var timePitchNodes: [Int: AVAudioUnitTimePitch] = [:]
    private var buffers: [Int: AVAudioPCMBuffer] = [:]
    
    @Published var bpm: Double = 94.0 {
        didSet {
            adjustPlaybackRates()
        }
    }
    
    @Published var pitchLock: Bool = false {
        didSet {
            adjustPlaybackRates()
        }
    }
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
    func loadSamples(_ samples: [Sample]) {
        // Create a common start time in the future
        let startDelay: TimeInterval = 1.0 // Start after 1 second
        
        // Get the current host time
        let nowHostTime = mach_absolute_time()
        
        // Convert delay from seconds to host time units
        let delayInHostTime = secondsToHostTime(startDelay)
        let startHostTime = nowHostTime + delayInHostTime
        
        // Create an AVAudioTime with the future host time
        let startTime = AVAudioTime(hostTime: startHostTime)
        
        // Attach and connect all nodes
        for sample in samples {
            let player = AVAudioPlayerNode()
            let mixer = AVAudioMixerNode()
            let varispeed = AVAudioUnitVarispeed()
            let timePitch = AVAudioUnitTimePitch()
            
            engine.attach(player)
            engine.attach(varispeed)
            engine.attach(timePitch)
            engine.attach(mixer)
            
            let fileName = sample.fileName.replacingOccurrences(of: "-body.wav", with: "")
            
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "wav") else {
                print("Could not find file \(sample.fileName)")
                continue
            }
            
            do {
                let file = try AVAudioFile(forReading: url)
                
                // Read the entire file into a buffer
                let processingFormat = file.processingFormat
                let frameCount = AVAudioFrameCount(file.length)
                guard let buffer = AVAudioPCMBuffer(pcmFormat: processingFormat, frameCapacity: frameCount) else { continue }
                try file.read(into: buffer)
                buffers[sample.id] = buffer
                
                // Connect nodes
                engine.connect(player, to: varispeed, format: processingFormat)
                engine.connect(varispeed, to: timePitch, format: processingFormat)
                engine.connect(timePitch, to: mixer, format: processingFormat)
                engine.connect(mixer, to: engine.mainMixerNode, format: processingFormat)
                
                players[sample.id] = player
                mixers[sample.id] = mixer
                varispeedNodes[sample.id] = varispeed
                timePitchNodes[sample.id] = timePitch
                
                // Adjust playback rates
                adjustPlaybackRates(for: sample)
                
                // Set initial volume to 0 (mute)
                mixer.outputVolume = 0.0
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        }
        
        // Connect the main mixer node to the output node
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: nil)
        
        // Prepare and start the engine after setting up all nodes
        engine.prepare()
        do {
            try engine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
        
        // Schedule buffers and start players
        for sample in samples {
            guard let player = players[sample.id],
                  let buffer = buffers[sample.id] else { continue }
            
            // Schedule buffer
            player.scheduleBuffer(buffer, at: startTime, options: .loops, completionHandler: nil)
            
            // Start the player
            player.play(at: startTime)
        }
    }
    
    func setVolume(for sample: Sample, volume: Float) {
        guard let mixer = mixers[sample.id] else { return }
        mixer.outputVolume = volume
    }
    
    private func adjustPlaybackRates() {
        for sample in samples {
            adjustPlaybackRates(for: sample)
        }
    }
    
    private func adjustPlaybackRates(for sample: Sample) {
        guard let varispeed = varispeedNodes[sample.id],
              let timePitch = timePitchNodes[sample.id] else { return }
        
        let rate = bpm / sample.bpm
        
        if pitchLock {
            varispeed.rate = 1.0
            timePitch.rate = Float(rate)
            timePitch.pitch = 0.0 // No pitch shift
        } else {
            varispeed.rate = Float(rate)
            timePitch.rate = 1.0
            timePitch.pitch = 0.0
        }
    }
    
    // Helper function to convert seconds to host time units
    private func secondsToHostTime(_ seconds: TimeInterval) -> UInt64 {
        var timebaseInfo = mach_timebase_info_data_t()
        mach_timebase_info(&timebaseInfo)
        let nanos = seconds * Double(NSEC_PER_SEC)
        let hostTime = nanos * Double(timebaseInfo.denom) / Double(timebaseInfo.numer)
        return UInt64(hostTime)
    }
}
