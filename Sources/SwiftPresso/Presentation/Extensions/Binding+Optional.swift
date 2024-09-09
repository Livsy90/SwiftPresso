import SwiftUI

extension Binding where Value == Bool {
    
    init<Wrapped>(mapped: Binding<Wrapped?>) {
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
    
    func boolValue<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        Binding<Bool>(mapped: self)
    }
    
}
