//
//  DiatonicChordListView.swift
//  KeySuggestionFeature
//
//  Created by Shunya Yamada on 2025/07/27.
//

import SwiftUI
import SharedModels

/// ダイアトニックコード表示専用ビュー
public struct DiatonicChordListView: View {
    let selectedKey: Key
    let diatonicChords: [DiatonicChord]
    let onChordSelected: (DiatonicChord) -> Void
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // ヘッダー
            headerSection
            
            // コード一覧
            chordListSection
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    public init(
        selectedKey: Key,
        diatonicChords: [DiatonicChord],
        onChordSelected: @escaping (DiatonicChord) -> Void
    ) {
        self.selectedKey = selectedKey
        self.diatonicChords = diatonicChords
        self.onChordSelected = onChordSelected
    }
}

// MARK: - View Components

private extension DiatonicChordListView {
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(selectedKey.name)キーのダイアトニックコード")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                // キー情報
                VStack(alignment: .trailing, spacing: 2) {
                    Text(selectedKey.shortName)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    if selectedKey.keySignature.accidentals != 0 {
                        Text(selectedKey.keySignature.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Text("コードをタップして新しい検索を開始")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    var chordListSection: some View {
        LazyVGrid(columns: adaptiveColumns, spacing: 12) {
            ForEach(diatonicChordsByDegree, id: \.0) { degree, diatonicChord in
                DiatonicChordDetailCard(
                    diatonicChord: diatonicChord,
                    onTap: { onChordSelected(diatonicChord) }
                )
            }
        }
    }
    
    // レスポンシブレイアウト（iPhone/iPad対応）
    var adaptiveColumns: [GridItem] {
        [GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom == .pad ? 200 : 160), spacing: 12)]
    }
    
    // 度数順に並べたダイアトニックコード
    var diatonicChordsByDegree: [(ScaleDegree, DiatonicChord)] {
        return diatonicChords.map { chord in
            (chord.degree, chord)
        }.sorted { $0.0.rawValue < $1.0.rawValue }
    }
}

// MARK: - Detail Card Component

struct DiatonicChordDetailCard: View {
    let diatonicChord: DiatonicChord
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // 度数とローマ数字表記
                VStack(spacing: 4) {
                    Text(diatonicChord.degree.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                    
                    Text(diatonicChord.romanNumeral)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                // コードシンボル
                Text(diatonicChord.chord.symbol)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Divider()
                
                // ハーモニック機能の表示
                VStack(spacing: 4) {
                    Text(diatonicChord.function.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(harmonicFunctionColor(for: diatonicChord.function))
                    
                    Text(diatonicChord.function.description)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(harmonicFunctionColor(for: diatonicChord.function).opacity(0.3), lineWidth: 2)
                )
        )
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: false)
    }
    
    private func harmonicFunctionColor(for function: HarmonicFunction) -> Color {
        switch function {
        case .tonic:
            return .green
        case .subdominant:
            return .orange
        case .dominant:
            return .red
        }
    }
}

// MARK: - Extensions

private extension ScaleDegree {
    var displayName: String {
        switch self {
        case .i: return "I度"
        case .ii: return "II度"
        case .iii: return "III度"
        case .iv: return "IV度"
        case .v: return "V度"
        case .vi: return "VI度"
        case .vii: return "VII度"
        }
    }
}

#Preview {
    DiatonicChordListView(
        selectedKey: Key(tonic: .c, mode: .major),
        diatonicChords: [
            DiatonicChord(
                degree: .i,
                chord: Chord(root: .c, quality: .major),
                function: .tonic,
                romanNumeral: "I"
            ),
            DiatonicChord(
                degree: .ii,
                chord: Chord(root: .d, quality: .minor),
                function: .subdominant,
                romanNumeral: "ii"
            ),
            DiatonicChord(
                degree: .v,
                chord: Chord(root: .g, quality: .major),
                function: .dominant,
                romanNumeral: "V"
            )
        ],
        onChordSelected: { _ in }
    )
}