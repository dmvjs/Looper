import Foundation
import Combine

protocol AudioManaging: ObservableObject, AnyObject where ObjectWillChangePublisher == ObservableObjectPublisher {
    var bpm: Double { get set }
    var pitchLock: Bool { get set }
    var samples: [Sample] { get set }
    var groupedSamples: [BPMGroup] { get }
    
    func setVolume(for sample: Sample, volume: Float)
    func fadeOutSample(_ sample: Sample, duration: TimeInterval)
    func loadSamples(_ samples: [Sample])
    func playSample(_ sample: Sample)
    func stopSample(_ sample: Sample)
}
