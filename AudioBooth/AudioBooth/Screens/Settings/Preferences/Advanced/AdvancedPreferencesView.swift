import CoreNFC
import SwiftUI

struct AdvancedPreferencesView: View {
  @ObservedObject var preferences = UserPreferences.shared

  var body: some View {
    Form {
      Section {
        Toggle(isOn: $preferences.iCloudSyncEnabled) {
          PreferenceRow(
            systemImage: "icloud.fill",
            tint: .blue,
            title: "iCloud Sync"
          )
        }
        .listRowBackground(Color.Background.card)
        .onChange(of: preferences.iCloudSyncEnabled) { _, enabled in
          if enabled {
            preferences.syncToCloud()
          } else {
            preferences.purgeCloud()
          }
        }
      } header: {
        Text("iCloud")
      } footer: {
        Text("Sync your preferences across all your devices using iCloud.")
          .font(.caption)
      }

      if NFCNDEFReaderSession.readingAvailable {
        Section {
          Toggle(isOn: $preferences.showNFCTagWriting) {
            PreferenceRow(
              systemImage: "wave.3.right",
              tint: .indigo,
              title: "NFC Tag Writing"
            )
          }
          .listRowBackground(Color.Background.card)
        } header: {
          Text("NFC")
        } footer: {
          Text("Show option in book details menu to write book information to NFC tags for quick playback access.")
            .font(.caption)
        }
      }
    }
    .scrollContentBackground(.hidden)
    .background(Color.Background.page)
    .navigationTitle("Advanced")
  }
}

#Preview {
  NavigationStack {
    AdvancedPreferencesView()
  }
}
