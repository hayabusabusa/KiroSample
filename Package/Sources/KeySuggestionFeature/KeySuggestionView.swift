//
//  KeySuggestionView.swift
//  Package
//
//  Created by Shunya Yamada on 2025/07/21.
//

import SwiftUI
import SharedModels

public struct KeySuggestionView: View {
    @State private var viewModel = KeySuggestionViewModel()

    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // コード入力セクション
                    chordInputSection

                    // ソート・フィルタリングコントロール
                    if !viewModel.suggestedKeys.isEmpty {
                        sortingAndFilteringSection
                    }

                    // キー提案リスト
                    keySuggestionListSection

                    // ダイアトニックコード表示セクション
                    if viewModel.hasDiatonicChords {
                        diatonicChordsSection
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("ダイアトニックコード学習")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    public init(viewModel: KeySuggestionViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - View Components

private extension KeySuggestionView {
    
    // コード入力フィールドとリアルタイムバリデーション表示
    var chordInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("コードを入力してください")
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField("例: C, Am, F7, Dm7", text: $viewModel.chordInput)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onChange(of: viewModel.chordInput) { _, newValue in
                    viewModel.validateInput(newValue)
                }
                .onSubmit {
                    Task {
                        await viewModel.processChordInput()
                    }
                }
            
            // エラーメッセージ表示
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
            
            // 検索ボタン
            Button("キーを検索") {
                Task {
                    await viewModel.processChordInput()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.chordInput.isEmpty || viewModel.errorMessage != nil)
        }
    }
    
    // ソート・フィルタリング機能のUI実装
    var sortingAndFilteringSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("表示設定")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
            }
            
            // ソート順序選択
            HStack {
                Text("ソート:")
                    .font(.caption)
                
                Picker("ソート順", selection: $viewModel.sortOrder) {
                    ForEach(KeySuggestionSortOrder.allCases, id: \.self) { order in
                        Text(order.description).tag(order)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.sortOrder) { _, newValue in
                    viewModel.changeSortOrder(to: newValue)
                }
            }
            
            // フィルタリングと詳細表示オプション
            HStack {
                Toggle("標準キーのみ", isOn: $viewModel.showOnlyStandardKeys)
                    .font(.caption)
                    .onChange(of: viewModel.showOnlyStandardKeys) { _, _ in
                        viewModel.toggleStandardKeysFilter()
                    }
                
                Spacer()
                
                Button("詳細表示") {
                    viewModel.toggleDetailedExplanation()
                }
                .font(.caption)
                .foregroundColor(viewModel.showDetailedExplanation ? .blue : .secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    // キー提案リストのカスタムレイアウト
    var keySuggestionListSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !viewModel.suggestedKeys.isEmpty {
                HStack {
                    Text("キー候補 (\(viewModel.displaySuggestions.count))")
                        .font(.headline)
                    Spacer()
                }
                
                LazyVStack(spacing: 4) {
                    ForEach(viewModel.displaySuggestions, id: \.suggestion.key) { displaySuggestion in
                        KeySuggestionRow(
                            displaySuggestion: displaySuggestion,
                            onTap: {
                                Task {
                                    await viewModel.selectSuggestion(displaySuggestion.suggestion)
                                }
                            }
                        )
                    }
                }
            } else if !viewModel.chordInput.isEmpty && viewModel.errorMessage == nil {
                Text("キー候補を検索中...")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    // ダイアトニックコード表示セクション
    var diatonicChordsSection: some View {
        Group {
            if let selectedKey = viewModel.selectedKey {
                DiatonicChordListView(
                    selectedKey: selectedKey,
                    diatonicChords: viewModel.diatonicChords,
                    onChordSelected: { diatonicChord in
                        Task {
                            await viewModel.selectDiatonicChord(diatonicChord)
                        }
                    }
                )
            }
        }
    }
}

// MARK: - Supporting Views

struct KeySuggestionRow: View {
    let displaySuggestion: DisplayKeySuggestion
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(displaySuggestion.suggestion.key.name)
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        Text("(\(displaySuggestion.suggestion.key.mode.rawValue))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        // 信頼度表示
                        Text(displaySuggestion.confidenceLevel.description)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(confidenceColor(for: displaySuggestion.confidenceLevel))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                    
                    Text(displaySuggestion.suggestion.reason)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                    
                    if let detailedReason = displaySuggestion.detailedReason {
                        Text(detailedReason)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                Text(String(format: "%.1f", displaySuggestion.suggestion.score))
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)
        .background(displaySuggestion.isSelected ? Color.blue.opacity(0.1) : Color(.systemBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(displaySuggestion.isSelected ? Color.blue : Color(.systemGray4), lineWidth: 1)
        )
    }
    
    private func confidenceColor(for level: ConfidenceLevel) -> Color {
        switch level.colorHint {
        case "green": return .green
        case "blue": return .blue
        case "orange": return .orange
        case "yellow": return .yellow
        case "red": return .red
        default: return .gray
        }
    }
}


#Preview {
    KeySuggestionView(
        viewModel: KeySuggestionViewModel()
    )
}
