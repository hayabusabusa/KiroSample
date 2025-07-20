# Implementation Plan

- [ ] 1. プロジェクトセットアップとコア構造
  - [ ] 1.1 Xcodeプロジェクト作成とターゲット設定
    - 新しいiOSプロジェクトを作成し、iOS 17.0以降に設定
    - SwiftUIとSwift Concurrencyを有効化
    - プロジェクト構造に基づくフォルダ階層を作成
    - _要件: 全般_

  - [ ] 1.2 Swift Package Manager依存関係設定
    - Package.swiftファイルの作成と基本設定
    - 必要な外部ライブラリの依存関係追加（テスト用Mock等）
    - ビルド設定とデプロイメントターゲットの確認
    - _要件: 全般_

- [ ] 2. データモデルとコアインフラ実装
  - [ ] 2.1 基本データモデル実装
    - Store、WaitTime、BusinessHours、Coordinateモデルの実装
    - Decodable、Sendable、Equatableプロトコル準拠
    - ドキュメントコメントの追加とプロパティ定義
    - _要件: 1.2, 2.1_

  - [ ] 2.2 エラーハンドリングとフィルタリングモデル
    - APIErrorエラー型の実装とLocalizedError準拠
    - FilterCriteriaモデルの実装
    - カラーコード計算ロジックの実装とテスト
    - _要件: 1.3, 1.4, 5.1_

- [ ] 3. データ層実装（Repository + APIClient）
  - [ ] 3.1 APIClient基盤実装
    - APIClientProtocolインターフェース定義
    - URLSessionベースのAPIClient実装
    - Swift Concurrencyを活用した非同期通信
    - タイムアウトとリトライ機能の実装
    - _要件: 1.3, 1.4, 4.1_

  - [ ] 3.2 Repository層実装
    - StoreRepositoryProtocolインターフェース定義
    - StoreRepository実装（APIClient + LocalStorage統合）
    - キャッシュ機能の実装（UserDefaults/FileManager使用）
    - エラーハンドリングと例外処理
    - _要件: 1.1, 1.2, 4.2_

- [ ] 4. ビジネスロジック層実装（Services）
  - [ ] 4.1 StoreService（Actor）実装
    - StoreServiceProtocolインターフェース定義
    - Actor-basedなStoreServiceの実装
    - Repository経由でのデータ取得ロジック
    - キャッシュ戦略とデータ一貫性の実装
    - _要件: 1.1, 1.2, 4.1_

  - [ ] 4.2 LocationServiceとネットワーク最適化
    - 位置情報サービスの実装（CoreLocation使用）
    - ネットワーク状態監視機能の実装
    - パフォーマンス最適化（Task cancellation等）
    - _要件: 3.3, 3.5_

- [ ] 5. プレゼンテーション層実装（ViewModels + Views）
  - [ ] 5.1 StoreListViewModel実装
    - @ObservableマクロとObservation Framework使用
    - 店舗一覧取得・更新・検索・フィルタリング機能
    - エラーハンドリングとローディング状態管理
    - _要件: 1.1, 1.2, 4.1, 5.1-5.5_

  - [ ] 5.2 StoreDetailViewModel実装
    - 店舗詳細情報の取得と表示管理
    - 電話発信とマップアプリ連携機能
    - 位置情報とMapKit統合
    - _要件: 3.1-3.5_

  - [ ] 5.3 StoreListView（SwiftUI）実装
    - 店舗一覧表示のSwiftUIビュー実装
    - プルトゥリフレッシュ機能（RefreshableModifier使用）
    - 検索バーとフィルタリングUI
    - 色分けされた待ち時間表示
    - _要件: 1.1, 1.2, 2.1-2.6, 4.1-4.4, 5.1-5.5_

  - [ ] 5.4 StoreDetailView（SwiftUI）実装
    - 店舗詳細情報表示のSwiftUIビュー
    - MapKit統合による地図表示
    - 電話番号・住所タップによる外部アプリ連携
    - NavigationStackによる画面遷移
    - _要件: 3.1-3.5_

  - [ ] 5.5 SearchFilterView実装
    - 検索とフィルタリング用のUIコンポーネント
    - 検索クエリの入力ハンドリング
    - フィルター条件の選択UI（待ち時間、営業状態、地域）
    - _要件: 5.1-5.5_

- [ ] 6. テスト実装
  - [ ] 6.1 データモデルのUnit Testing
    - Swift Testing使用したモデルテスト実装
    - Equatableプロトコルを活用した比較テスト
    - WaitTimeの色分けロジックテスト
    - FilterCriteriaのフィルタリングロジックテスト
    - _要件: 2.1-2.6, 5.1-5.5_

  - [ ] 6.2 Repository層のUnit Testing
    - StoreRepositoryのモックテスト実装
    - APIClient層のモックとネットワークテスト
    - エラーハンドリングのテストケース
    - キャッシュ機能の動作テスト
    - _要件: 1.3, 1.4, 4.1-4.4_

  - [ ] 6.3 ViewModel層のUnit Testing
    - @MainActorを使用したViewModelテスト
    - 非同期処理のテスト（async/await）
    - モックサービスを使用した統合テスト
    - エラーハンドリングとローディング状態テスト
    - _要件: 全要件_

  - [ ] 6.4 Integration Testing
    - Service + Repository統合テスト
    - ViewModel + Service統合テスト
    - Mock Serverを使用したE2Eテスト
    - _要件: 全要件_

## 進捗状況
- Created: 2025-07-20T15:20:00Z
- Status: Ready for implementation
- Total tasks: 19
- Completed: 0
- Remaining: 19

## 要件マッピング
- **要件1（店舗一覧表示）**: タスク 2.1, 3.2, 4.1, 5.1, 5.3
- **要件2（待ち時間表示）**: タスク 2.1, 2.2, 5.1, 5.3, 6.1
- **要件3（店舗詳細）**: タスク 4.2, 5.2, 5.4
- **要件4（手動更新）**: タスク 3.1, 4.1, 5.1, 5.3
- **要件5（検索・フィルタ）**: タスク 2.2, 5.1, 5.5

## 実装順序
1. **フェーズ1**: タスク1-2（基盤とモデル）
2. **フェーズ2**: タスク3-4（データ層・ビジネスロジック）
3. **フェーズ3**: タスク5（プレゼンテーション層）
4. **フェーズ4**: タスク6（テスト）