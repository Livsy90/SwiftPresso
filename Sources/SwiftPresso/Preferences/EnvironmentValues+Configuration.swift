import SwiftUI

extension EnvironmentValues {
    @Entry var configuration: Preferences.Configuration = Preferences.shared.configuration
}
