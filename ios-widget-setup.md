
# iOS Widget Setup (Focus Timer + Tasks Left)

**This repository ships RN screens for Focus/Health/etc. The actual home-screen widgets require native iOS.**

Steps (high-level):
1) `npx expo prebuild` (or eject) so you have `/ios` native project.
2) Open `ios/Leverage.xcworkspace` in Xcode.
3) File → New → Target → Widget Extension. Name it `LeverageWidgets`. Make sure to enable **App Groups** capability on both the main app and the widget (e.g., `group.com.yourcompany.leverage`).
4) In RN, store a compact JSON into App Group using a native module:
   - You can write your own, or use `react-native-shared-group-preferences` (needs config).
   - Example schema:
   ```json
   { "focusSecondsRemaining": 1200, "tasksLeftToday": 5, "health": 0.72 }
   ```
5) In SwiftUI `TimelineProvider`, read the JSON from App Group and render:
   - Focus Timer widget
   - Tasks Left widget
   - Health Bar widget

This is a starter snippet you can paste into your Widget extension's `LeverageWidgets.swift`:

```swift
import WidgetKit
import SwiftUI

struct LeverageData: Codable {
    var focusSecondsRemaining: Int
    var tasksLeftToday: Int
    var health: Double
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry { SimpleEntry(date: Date(), data: .init(focusSecondsRemaining: 1500, tasksLeftToday: 7, health: 0.66)) }
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: Date(), data: readSharedData()))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date(), data: readSharedData())
        // refresh every 5 minutes
        let next = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    func readSharedData() -> LeverageData {
        let defaults = UserDefaults(suiteName: "group.com.yourcompany.leverage")!
        if let s = defaults.string(forKey: "widget_payload"),
           let d = s.data(using: .utf8),
           let model = try? JSONDecoder().decode(LeverageData.self, from: d) {
            return model
        }
        return .init(focusSecondsRemaining: 1500, tasksLeftToday: 7, health: 0.66)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: LeverageData
}

struct LeverageWidgetsEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        VStack(alignment: .leading) {
            Text("Focus").font(.caption).foregroundColor(.secondary)
            Text(timeString(entry.data.focusSecondsRemaining)).font(.title).bold()
            ProgressView(value: entry.data.health)
        }.padding()
    }

    func timeString(_ seconds: Int) -> String {
        let m = seconds/60, s = seconds%60
        return String(format: "%02d:%02d", m, s)
    }
}

@main
struct LeverageWidgets: Widget {
    let kind: String = "LeverageWidgets"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LeverageWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Leverage Focus")
        .description("Focus timer and health.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
```

Then, from RN when things change (timer tick, tasks updated), write JSON into the App Group key `widget_payload` so the widget picks up the latest values on next refresh.
