import SwiftUI

struct GeneralPreferencesView: View {
  @ObservedObject var preferences = UserPreferences.shared
  @ObservedObject private var iconModel = AppIconPickerViewModel.shared

  var body: some View {
    Form {
      Section("Behavior") {
        Toggle(isOn: $preferences.openPlayerOnLaunch) {
          PreferenceRow(
            systemImage: "play.circle",
            tint: .green,
            title: "Open Player on Launch",
            subtitle: "Skip the home screen on reopen"
          )
        }
        .listRowBackground(Color.Background.card)

        Toggle(isOn: $preferences.hapticsEnabled) {
          PreferenceRow(
            systemImage: "bolt",
            tint: .orange,
            title: "Haptic Feedback",
            subtitle: "Subtle vibrations on controls"
          )
        }
        .listRowBackground(Color.Background.card)
      }

      Section("Appearance") {
        AppIconPickerView()
          .listRowBackground(Color.Background.card)

        AccentColorPickerView()
          .listRowBackground(Color.Background.card)

        ColorSchemePickerView()
          .listRowBackground(Color.Background.card)

        #if targetEnvironment(macCatalyst)
        Stepper(value: $preferences.displayScale, in: 0.8...2.0, step: 0.05) {
          HStack {
            Text("Display Scale")
              .font(.subheadline)
              .bold()
            Spacer()
            Text(preferences.displayScale, format: .percent.precision(.fractionLength(0)))
              .font(.subheadline)
              .foregroundStyle(.secondary)
          }
        }
        .listRowBackground(Color.Background.card)
        #endif

        if preferences.accentColor != nil || preferences.colorScheme != .auto || iconModel.currentIcon != .default {
          Button {
            preferences.accentColor = nil
            preferences.colorScheme = .auto
            iconModel.setAlternateAppIcon(icon: .default)
          } label: {
            Text("Reset Appearance to Default")
              .font(.subheadline)
              .bold()
              .foregroundStyle(.primary)
              .frame(maxWidth: .infinity, alignment: .center)
          }
          .buttonStyle(.plain)
          .listRowBackground(Color.Background.card)
        }
      }
    }
    .scrollContentBackground(.hidden)
    .background(Color.Background.page)
    .navigationTitle("General")
  }

}

#Preview {
  NavigationStack {
    GeneralPreferencesView()
  }
}
