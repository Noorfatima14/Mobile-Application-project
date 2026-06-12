
# Leverage (Minimal Habitica-like iOS app)

Expo Router + React Native app with minimalist UI and gamified elements (Leverage Points).

## Pages
- Home (overview + health bars)
- Today (daily tasks)
- Calendar (simple add/list)
- Habits (toggle today, streaks)
- Tasks (priorities, up to 3 levels of subtasks)
- Rewards (buy feature unlocks with LP)
- Focus (25-minute countdown; awards LP)
- Eisenhower Matrix (locked reward)
- Priority AI chat (locked reward; wire your API)

## Run
```bash
npm i
npx expo start
# or: npm run ios
```

## Color Scheme
- bg `#0B0B0D` (near-black)
- accent `#8B5CF6` (soft purple)
- text `#F5F5F7`

## Widgets (iOS)
Real iOS home-screen widgets require a WidgetKit extension and an App Group to share data. In Expo, that means:
1. `npx expo prebuild` to generate native ios project.
2. Add a WidgetKit extension in Xcode and read data from the shared App Group.
3. From RN, write JSON into the App Group path (via a native module or a lib like react-native-shared-group-preferences).
4. Build/run from Xcode.

See `ios-widget-setup.md` for a tiny stub snippet to start.
