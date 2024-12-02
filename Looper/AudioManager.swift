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
    private var referenceStartTime: AVAudioTime?
    
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
        setupEngineNodes()
        startEngine()
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
    
    private func setupEngineNodes() {
        // Attach the main output node if necessary
        let mainMixer = engine.mainMixerNode
        engine.connect(mainMixer, to: engine.outputNode, format: nil)
    }
    
    private func startEngine() {
        do {
            try engine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }
    
    func addSampleToPlay(_ sample: Sample) {
        let player = AVAudioPlayerNode()
        let mixer = AVAudioMixerNode()
        let varispeed = AVAudioUnitVarispeed()
        let timePitch = AVAudioUnitTimePitch()
        
        engine.attach(player)
        engine.attach(varispeed)
        engine.attach(timePitch)
        engine.attach(mixer)
        
        guard let url = Bundle.main.url(forResource: sample.fileName, withExtension: "wav") else {
            print("Could not find file \(sample.fileName)")
            return
        }
        
        do {
            let file = try AVAudioFile(forReading: url)
            
            // Read the entire file into a buffer
            let processingFormat = file.processingFormat
            let frameCount = AVAudioFrameCount(file.length)
            guard let buffer = AVAudioPCMBuffer(pcmFormat: processingFormat, frameCapacity: frameCount) else { return }
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
            
            // Set a reference start time if it hasn't been set
            if referenceStartTime == nil {
                referenceStartTime = AVAudioTime(hostTime: mach_absolute_time() + secondsToHostTime(1.0)) // Start after 1 second delay
            }
            
            // Stop all players, reschedule buffers, and restart to maintain phase alignment
            stopAllPlayers()
            players[sample.id] = player
            scheduleAllPlayers()
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }
    
    private func stopAllPlayers() {
        for player in players.values {
            player.stop()
        }
    }
    
    private func scheduleAllPlayers() {
        guard let startTime = referenceStartTime else { return }
        for (sampleId, player) in players {
            if let buffer = buffers[sampleId] {
                player.scheduleBuffer(buffer, at: startTime, options: .loops, completionHandler: nil)
                player.play(at: startTime)
            }
        }
    }
    
    func removeSampleFromPlay(_ sample: Sample) {
        guard let player = players[sample.id] else { return }

        player.stop()
        engine.detach(player)
        
        if let mixer = mixers[sample.id] {
            engine.detach(mixer)
        }
        if let varispeed = varispeedNodes[sample.id] {
            engine.detach(varispeed)
        }
        if let timePitch = timePitchNodes[sample.id] {
            engine.detach(timePitch)
        }
        
        players.removeValue(forKey: sample.id)
        mixers.removeValue(forKey: sample.id)
        varispeedNodes.removeValue(forKey: sample.id)
        timePitchNodes.removeValue(forKey: sample.id)
        buffers.removeValue(forKey: sample.id)
        
        // Reschedule remaining players to maintain phase alignment
        stopAllPlayers()
        scheduleAllPlayers()
    }
    
    func setVolume(for sample: Sample, volume: Float) {
        guard let mixer = mixers[sample.id] else { return }
        mixer.outputVolume = volume
    }
    
    private func adjustPlaybackRates() {
        for sampleId in players.keys {
            if let sample = samples.first(where: { $0.id == sampleId }) {
                adjustPlaybackRates(for: sample)
            }
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
