import SwiftUI
import Foundation

final class SPPreferences {
    
    static let shared: SPPreferences = .init()
    
    var configuration: SPConfiguration {
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
    private var _configuration = SPConfiguration.init(host: "")
    
    private init() {}
    
}
