import SwiftUI
import Foundation

final class Preferences {
    
    static let shared: Preferences = .init()
    
    var configuration: SwiftPressoConfiguration {
        get {
            queue.sync {
                _configuration
            }
        }
        set {
            queue.async(flags: .barrier) {
                self._configuration = newValue
            }
        }
    }
    
    private let queue = DispatchQueue(
        label: "com.sppreferences.queue",
        qos: .default,
        attributes: .concurrent
    )
    private var _configuration = SwiftPressoConfiguration.init(host: "")
    
    private init() {}
    
}
