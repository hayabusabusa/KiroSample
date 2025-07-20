# Project Structure

## Root Directory Organization
```
KiroSample/
├── .kiro/                    # Kiro spec-driven development files
│   ├── steering/            # プロジェクト指針ドキュメント
│   └── specs/               # 機能仕様書
├── App/                     # メインiOSアプリケーション
│   ├── App.xcodeproj        # Xcodeプロジェクトファイル
│   ├── App/                 # アプリケーションソースコード
│   ├── AppTests/            # ユニットテスト
│   └── AppUITests/          # UIテスト
├── Package/                 # Swift Package Manager モジュール群
│   ├── Package.swift        # パッケージ定義
│   ├── Sources/             # ソースコード
│   └── Tests/               # テストコード
├── Sawayaka.xcworkspace     # Xcodeワークスペース
├── CLAUDE.md                # Claude Code指示書
└── README.md                # プロジェクトドキュメント
```

## App Directory Structure

### `/App/App/`
```
App/
├── SawayakaApp.swift       # アプリケーションエントリーポイント(@main)
├── Assets.xcassets/        # アプリアイコン、画像リソース
└── Preview Content/        # SwiftUIプレビュー用リソース
```

## Package Module Structure

### `/Package/Sources/`
```
Sources/
├── AppFeature/             # アプリケーション統合モジュール
│   └── AppView.swift       # ルートビュー
├── Domain/                 # ビジネスロジック層
│   ├── Repositories/       # データアクセス抽象化
│   │   └── StoreRepository.swift
│   └── Services/           # ビジネスサービス
│       └── StoreService.swift
├── HomeFeature/            # ホーム画面機能
│   └── HomeView.swift      # 店舗一覧・検索画面
├── SettingsFeature/        # 設定画面機能
│   └── SettingsView.swift  # アプリ設定画面
├── SharedExtensions/       # 共通拡張機能
│   └── Utils/              # ユーティリティ関数
│       └── String+.swift   # String拡張
└── SharedModels/           # 共通データモデル
    ├── Entity/             # エンティティモデル
    │   └── Store.swift     # 店舗モデル
    ├── DTO/                # データ転送オブジェクト
    └── Enums/              # 列挙型定義
```

## Code Organization Patterns
- **Modular Architecture**: 機能別パッケージ分割による疎結合設計
- **MVVM + Repository Pattern**: データ層分離とテスタビリティ向上
- **Feature-Driven Development**: 機能単位での独立開発とテスト
- **Dependency Injection**: プロトコル指向による依存性注入

## File Naming Conventions
- **Swift Files**: PascalCase + 機能サフィックス
  - `StoreListView.swift` (View)
  - `StoreListViewModel.swift` (ViewModel) 
  - `StoreRepository.swift` (Repository)
  - `StoreService.swift` (Service)
  - `Store.swift` (Model/Entity)
- **Feature Modules**: PascalCase + "Feature"サフィックス
  - `HomeFeature`, `SettingsFeature`
- **Test Files**: 対象ファイル名 + `Tests.swift`
  - `StoreServiceTests.swift`

## Import Organization
```swift
// 1. Foundation/System imports
import Foundation
import SwiftUI

// 2. Apple framework imports  
import CoreLocation
import MapKit

// 3. Internal module imports (アルファベット順)
import Domain
import SharedModels
import SharedExtensions
```

## Key Architectural Principles
- **Single Responsibility**: 各モジュール・クラスは単一の責務を持つ
- **Dependency Inversion**: 具象ではなく抽象（Protocol）に依存
- **Modular Design**: 機能別モジュール分割による保守性向上
- **Protocol-Oriented Programming**: Swift標準のプロトコル指向設計
- **Async/Await First**: Swift Concurrencyを優先した非同期処理
- **Sendable Compliance**: Swift 6.0 Concurrency安全性の確保
- **Observation Framework**: iOS 17+ @Observableマクロによる状態管理

## Module Dependencies
```
AppFeature
├── HomeFeature
└── SettingsFeature

Domain  
└── SharedModels

HomeFeature
├── SharedExtensions
└── SharedModels

SettingsFeature
├── SharedExtensions  
└── SharedModels

SharedExtensions (依存なし)
SharedModels (依存なし)
```

## Testing Strategy
- **Unit Tests**: 各モジュール単位でのロジックテスト
- **Integration Tests**: モジュール間連携テスト
- **UI Tests**: エンドツーエンドシナリオテスト
- **Mock Strategy**: Protocolベースによるモック実装