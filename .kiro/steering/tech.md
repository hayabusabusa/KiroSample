# Technology Stack

## Architecture
- **Application Type**: iOSネイティブアプリケーション
- **Architecture Pattern**: Modular Architecture + MVVM
- **Deployment Target**: iOS 17.0+
- **Project Structure**: Xcode Project + Swift Package Manager モジュール構成
- **依存性管理**: Swift Package Manager (SPM)

## Frontend
- **UI Framework**: SwiftUI (iOS 17.0+)
- **State Management**: Observation Framework (@Observable)
- **Navigation**: NavigationStack
- **Async Programming**: Swift Concurrency (async/await, Actor)
- **Location Services**: CoreLocation
- **Map Integration**: MapKit

## Backend Integration
- **Networking**: URLSession with Swift Concurrency
- **Data Parsing**: Codable Protocol
- **Error Handling**: Result Type + Swift Error Protocol
- **Local Storage**: UserDefaults (設定), FileManager (キャッシュ)

## Development Environment
- **IDE**: Xcode 15.0+
- **Language**: Swift 6.0
- **Package Manager**: Swift Package Manager
- **Version Control**: Git
- **Testing Framework**: Swift Testing (iOS 17+)
- **Build System**: Xcode Build System + SPM

## Common Commands
```bash
# Xcodeプロジェクト操作
open Sawayaka.xcworkspace

# Swift Package Manager
swift build
swift test
swift package resolve
swift package clean

# Xcodeコマンドライン操作
xcodebuild -workspace Sawayaka.xcworkspace -scheme App -destination 'platform=iOS Simulator,name=iPhone 15' build
xcodebuild test -workspace Sawayaka.xcworkspace -scheme App -destination 'platform=iOS Simulator,name=iPhone 15'

# パッケージ構造確認
swift package show-dependencies
```

## Environment Variables
- **BUNDLE_IDENTIFIER**: App Bundle Identifier
- **DEVELOPMENT_TEAM**: Apple Developer Team ID  
- **CODE_SIGN_IDENTITY**: コード署名ID
- **SAWAYAKA_API_BASE_URL**: さわやかAPI基本URL (デフォルト設定済み)

## Port Configuration
- **Development Server**: N/A (ネイティブアプリ)
- **API Endpoint**: HTTPS (443) - 外部さわやかAPI
- **Debug Server**: Xcode Debugger (LLDB)

## Module Structure
```
App/                    # メインiOSアプリターゲット
Package/                # Swift Package Manager モジュール群
├── AppFeature          # アプリケーション全体統合
├── Domain              # ビジネスロジック・リポジトリ
├── HomeFeature         # ホーム画面機能
├── SettingsFeature     # 設定画面機能  
├── SharedExtensions    # 共通拡張機能
└── SharedModels        # 共通データモデル
```

## Build Configuration
- **Debug**: 開発用設定（最適化なし、デバッグシンボル含む）
- **Release**: リリース用設定（最適化あり、App Store配布用）
- **Testing**: テスト用設定（Mock対応、テストデータ使用）