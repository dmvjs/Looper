import Foundation
import AVFoundation
import Combine

class AudioManager: ObservableObject, AudioManaging {
    // MARK: - Properties
    private let engine = AVAudioEngine()
    private var players: [Int: AVAudioPlayerNode] = [:]
    private var mixers: [Int: AVAudioMixerNode] = [:]
    private var varispeedNodes: [Int: AVAudioUnitVarispeed] = [:]
    private var timePitchNodes: [Int: AVAudioUnitTimePitch] = [:]
    private var buffers: [Int: AVAudioPCMBuffer] = [:]
    
    @Published var bpm: Double = 84.0 {
        didSet {
            adjustPlaybackRates()
        }
    }
    
    @Published var pitchLock: Bool = false {
        didSet {
            adjustPlaybackRates()
        }
    }
    
    @Published var samples: [Sample] = [] // Conforms to AudioManaging
    
    @Published var groupedSamples: [BPMGroup] = [] // Conforms to AudioManaging
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    public init() { // Made initializer public
        setupAudioSession()
        setupGrouping()
        loadPersistedSettings()
        setupSettingsObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Audio Session Setup
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
            
            // Observe interruptions (e.g., phone calls)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleInterruption),
                name: AVAudioSession.interruptionNotification,
                object: audioSession
            )
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
    /// Handles audio session interruptions.
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }

        if type == .began {
            // Interruption began, stop all players
            stopAllPlayers()
        } else if type == .ended {
            // Interruption ended, check if should resume
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    startAllPlayers()
                }
            }
        }
    }
    
    // MARK: - Audio Managing Protocol Methods
    func loadSamples(_ samples: [Sample]) {
        self.samples = samples
        
        // Create a common start time in the future
        let startDelay: TimeInterval = 1.0 // Start after 1 second
        let startTime = AVAudioTime(hostTime: AVAudioTime.hostTime(fromSeconds: startDelay))
        
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
            
            let fileName = sample.fileName
            let fileExtension = "wav"
            
            guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
                print("Could not find file \(fileName).\(fileExtension)")
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
                print("Error loading audio file \(fileName): \(error.localizedDescription)")
            }
        }
        
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
    
    func fadeOutSample(_ sample: Sample, duration: TimeInterval) {
        guard let mixer = mixers[sample.id] else { return }
        mixer.outputVolume = 0.0 // Simple fade-out; consider implementing a gradual fade for smoother effect
    }
    
    func playSample(_ sample: Sample) {
        guard let player = players[sample.id] else { return }
        if !player.isPlaying {
            player.play()
        }
    }
    
    func stopSample(_ sample: Sample) {
        guard let player = players[sample.id] else { return }
        if player.isPlaying {
            player.stop()
        }
    }
    
    // MARK: - Playback Rate Adjustment
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
    
    // MARK: - Grouping Samples
    private func setupGrouping() {
        // Observe changes to samples to update groupedSamples
        $samples
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.groupSamples()
            }
            .store(in: &cancellables)
    }
    
    private func groupSamples() {
        let tempoGroups = Dictionary(grouping: samples) { $0.bpm }.sorted { $0.key < $1.key }
        groupedSamples = tempoGroups.map { (bpm, samples) in
            let keyGroups = Dictionary(grouping: samples) { $0.key }.sorted { $0.key < $1.key }
            let keyGroupStructs = keyGroups.map { KeyGroup(id: $0.key, samples: $0.value) }
            return BPMGroup(id: bpm, keyGroups: keyGroupStructs)
        }
    }
    
    // MARK: - Persistent Settings
    private func loadPersistedSettings() {
        if let savedBPM = UserDefaults.standard.value(forKey: "bpm") as? Double {
            bpm = savedBPM
        }
        if let savedPitchLock = UserDefaults.standard.value(forKey: "pitchLock") as? Bool {
            pitchLock = savedPitchLock
        }
    }
    
    private func savePersistedSettings() {
        UserDefaults.standard.set(bpm, forKey: "bpm")
        UserDefaults.standard.set(pitchLock, forKey: "pitchLock")
    }
    
    /// Sets up observers to persist settings when they change.
    private func setupSettingsObservers() {
        $bpm
            .sink { [weak self] _ in
                self?.savePersistedSettings()
            }
            .store(in: &cancellables)
        
        $pitchLock
            .sink { [weak self] _ in
                self?.savePersistedSettings()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Helper Functions
    /// Converts seconds to host time units for scheduling.
    private func secondsToHostTime(_ seconds: TimeInterval) -> UInt64 {
        var timebaseInfo = mach_timebase_info_data_t()
        mach_timebase_info(&timebaseInfo)
        let nanos = seconds * Double(NSEC_PER_SEC)
        let hostTime = nanos * Double(timebaseInfo.denom) / Double(timebaseInfo.numer)
        return UInt64(hostTime)
    }
    
    /// Stops all audio players.
    private func stopAllPlayers() {
        for player in players.values {
            player.stop()
        }
    }
    
    /// Starts all audio players.
    private func startAllPlayers() {
        for (id, player) in players {
            guard let buffer = buffers[id] else { continue }
            let startDelay: TimeInterval = 0.1
            let startTime = AVAudioTime(hostTime: AVAudioTime.hostTime(fromSeconds: startDelay))
            player.scheduleBuffer(buffer, at: startTime, options: .loops, completionHandler: nil)
            player.play(at: startTime)
        }
    }
}

extension AVAudioTime {
    /// Creates an AVAudioTime from seconds.
    static func hostTime(fromSeconds seconds: TimeInterval) -> UInt64 {
        var timebaseInfo = mach_timebase_info_data_t()
        mach_timebase_info(&timebaseInfo)
        let nanos = seconds * Double(NSEC_PER_SEC)
        let hostTime = nanos * Double(timebaseInfo.denom) / Double(timebaseInfo.numer)
        return UInt64(hostTime)
    }
}
