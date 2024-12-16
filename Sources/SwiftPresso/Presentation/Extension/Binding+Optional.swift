import SwiftUI

extension Binding where Value == Bool {
    
    init<Wrapped: Sendable>(mapped: Binding<Wrapped?>) {
        self.init(
            get: {
                mapped.wrappedValue != nil
            },
            set: { newValue in
                guard !newValue else { return }
                mapped.wrappedValue = nil
            }
        )
    }
    
}

extension Binding {
    
    func boolValue<Wrapped: Sendable>() -> Binding<Bool> where Value == Wrapped? {
        Binding<Bool>(mapped: self)
    }
    
}
