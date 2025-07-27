# 技術仕様

## 技術スタック

### プラットフォーム
- **iOS**: 17.0+
- **開発言語**: Swift 6.0+
- **UIフレームワーク**: SwiftUI

### 開発環境
- **IDE**: Xcode 15.0+
- **プロジェクト管理**: Xcode Workspace + Swift Package Manager
- **依存関係管理**: Swift Package Manager (SPM)

### アーキテクチャパターン
- **設計パターン**: MVVM（Model-View-ViewModel）
- **モジュール構成**: マルチモジュール（Feature-based）
- **依存関係注入**: プロトコルベースの依存関係注入

## プロジェクト構成

### Xcode Workspace
- **Workspace**: Diatonic.xcworkspace
- **メインアプリ**: App/App.xcodeproj
- **パッケージ**: Package/Package.swift

### Swift Package Manager構成

```swift
// Package.swift
products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "Domain", targets: ["Domain"]),
    .library(name: "KeySuggestionFeature", targets: ["KeySuggestionFeature"]),
    .library(name: "SharedModels", targets: ["SharedModels"]),
]
```

### モジュール依存関係

```
AppFeature → KeySuggestionFeature → Domain → SharedModels
                                 ↗
                      SharedModels
```

## アーキテクチャ詳細

### レイヤー構成

#### 1. Presentation Layer (Feature Modules)
- **AppFeature**: アプリケーションのエントリーポイント
- **KeySuggestionFeature**: キーサジェスト機能のUI/UX
  - KeySuggestionView (SwiftUI)
  - KeySuggestionViewModel (ObservableObject)

#### 2. Domain Layer
- **Services**: ビジネスロジック実装
  - KeySuggestionService: キーサジェストロジック
- **Repository Protocols**: データアクセス抽象化（将来拡張用）

#### 3. Data Layer (SharedModels)
- **Models**: ドメインオブジェクト
  - Key: 音楽のキー表現

### 設計原則

#### Clean Architecture準拠
- 依存関係は内側（SharedModels）から外側（AppFeature）への一方向
- ドメイン層はUI層に依存しない
- 抽象化（Protocol）を通じた疎結合

#### SOLID原則
- **Single Responsibility**: 各モジュールは単一責任
- **Open/Closed**: プロトコルを通じた拡張可能性
- **Liskov Substitution**: プロトコル準拠による置換可能性
- **Interface Segregation**: 最小限のインターフェース定義
- **Dependency Inversion**: 抽象への依存

## 開発コマンド

### ビルド・実行
```bash
# Xcodeでワークスペースを開く
open Diatonic.xcworkspace

# コマンドラインビルド（プロジェクトルートで実行）
xcodebuild -workspace Diatonic.xcworkspace -scheme App -destination 'platform=iOS Simulator,name=iPhone 15'
```

### テスト実行
```bash
# 単体テスト実行
xcodebuild test -workspace Diatonic.xcworkspace -scheme App -destination 'platform=iOS Simulator,name=iPhone 16'

# SPMパッケージテスト
swift test --package-path Package/
```

### パッケージ管理
```bash
# 依存関係解決
swift package --package-path Package/ resolve

# パッケージ更新
swift package --package-path Package/ update
```

## デプロイメント

### iOS App Store
- **Minimum Deployment Target**: iOS 17.0
- **Supported Devices**: iPhone, iPad
- **Architecture**: arm64 (デバイス), x86_64 (シミュレーター)

### 設定値
- **Bundle Identifier**: com.example.diatonic（変更予定）
- **Version**: 1.0.0
- **Build Number**: 1

## 開発環境セットアップ

### 必要なツール
1. **Xcode 15.0+**: App Storeからダウンロード
2. **Xcode Command Line Tools**: `xcode-select --install`
3. **iOS Simulator**: Xcode付属

### プロジェクト初期化
```bash
# リポジトリクローン（将来）
git clone [repository-url]
cd DiatonicSample

# Xcodeワークスペースを開く
open Diatonic.xcworkspace

# 初回ビルドで依存関係解決
# Xcode: Product → Build (⌘+B)
```

### 開発フロー
1. **機能開発**: 対応するFeatureモジュールで実装
2. **ドメインロジック**: Domainモジュールでサービス実装
3. **モデル追加**: SharedModelsに共通モデル追加
4. **テスト作成**: 各モジュールのTestsディレクトリ
5. **統合**: AppFeatureで機能統合

## パフォーマンス考慮事項

### メモリ使用量
- SwiftUIの@StateObject/@ObservedObjectを適切に使用
- 不要なViewの再描画を避ける

### レスポンス性能
- キーサジェスト処理の最適化
- 非同期処理でUIブロッキングを防止

### バッテリー効率
- 不要な計算処理を避ける
- アイドル時の処理を最小化

## セキュリティ考慮事項

### データ保護
- ユーザーデータのローカル保存（必要に応じて）
- 個人情報の取り扱い準拠

### コード品質
- SwiftLint導入検討
- 静的解析ツールの活用

## 拡張計画

### 将来の機能拡張
- コード進行分析機能
- MIDI入力対応
- カスタムスケール対応
- ユーザー設定保存

### 技術的拡張
- Core Data統合（データ永続化）
- CloudKit統合（データ同期）
- Widget Extension（ホーム画面ウィジェット）