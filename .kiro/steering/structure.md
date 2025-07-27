# プロジェクト構造

## 概要

このプロジェクトは、ダイアトニックコード学習アプリのためのマルチモジュール構成を採用しています。Swift Package Manager (SPM)を使用してモジュール化されており、機能単位で分離された設計になっています。

## アーキテクチャ

### プロジェクト構成

```
DiatonicSample/
├── App/                          # メインアプリプロジェクト
│   ├── App.xcodeproj            # Xcodeプロジェクト
│   ├── App/                     # アプリケーションエントリーポイント
│   │   ├── DiatonicApp.swift    # アプリケーション定義
│   │   ├── ContentView.swift    # 初期ビュー（未使用）
│   │   └── Assets.xcassets/     # アセット
│   ├── AppTests/                # アプリテスト
│   └── AppUITests/             # UIテスト
├── Package/                     # SPMパッケージ
│   ├── Package.swift           # パッケージ定義
│   └── Sources/                # モジュールソース
│       ├── AppFeature/         # アプリ機能モジュール
│       ├── Domain/             # ドメイン層
│       ├── KeySuggestionFeature/ # キーサジェスト機能
│       └── SharedModels/       # 共通モデル
├── Diatonic.xcworkspace        # Xcodeワークスペース
└── CLAUDE.md                   # プロジェクト指示書
```

## モジュール構成

### 1. AppFeature
- **役割**: アプリケーションのエントリーポイント
- **依存関係**: KeySuggestionFeature
- **説明**: アプリの最初の画面を定義し、KeySuggestionViewを表示

### 2. KeySuggestionFeature
- **役割**: キーサジェスト機能の UI と ViewModel
- **依存関係**: Domain, SharedModels
- **説明**: コード名入力によるキーサジェスト機能を提供

### 3. Domain
- **役割**: ビジネスロジックとサービス層
- **依存関係**: SharedModels
- **説明**: KeySuggestionServiceなどのドメインサービスを提供

### 4. SharedModels
- **役割**: 共通データモデル
- **依存関係**: なし
- **説明**: Key.swiftなど、アプリ全体で使用される共通モデルを定義

## 依存関係図

```
AppFeature → KeySuggestionFeature → Domain → SharedModels
                                 ↗
                      SharedModels
```

## ファイル組織

### 命名規則
- **モジュール名**: PascalCase（例：AppFeature, KeySuggestionFeature）
- **ファイル名**: PascalCase.swift（例：AppView.swift, KeySuggestionViewModel.swift）
- **ディレクトリ名**: PascalCase（モジュール内のサブディレクトリは必要に応じて）

### ディレクトリ構造
- **Sources/[ModuleName]/**: 各モジュールのソースコード
- **Tests/[ModuleName]Tests/**: 各モジュールのテストコード
- **App/**: メインアプリケーションのXcodeプロジェクト

## 設計原則

### 1. 単一責任の原則
各モジュールは明確に定義された単一の責任を持ちます。

### 2. 依存関係の方向
- UI層（Feature）→ ドメイン層（Domain）→ データ層（SharedModels）
- 下位層から上位層への依存は禁止

### 3. モジュラー設計
- 各機能は独立したモジュールとして実装
- 再利用可能性と保守性を重視

### 4. テスタビリティ
- 各モジュールは独立してテスト可能
- モックやスタブを使った単体テストを支援

## 開発ガイドライン

### 新機能の追加
1. SharedModelsに必要なデータモデルを追加
2. Domainに必要なサービスを実装
3. 新しいFeatureモジュールを作成（必要に応じて）
4. AppFeatureから新機能を統合

### モジュール間通信
- 依存関係注入を使用してサービスを渡す
- プロトコルを使用してモジュール間の結合を疎にする
- 共通のデータモデルはSharedModelsに配置