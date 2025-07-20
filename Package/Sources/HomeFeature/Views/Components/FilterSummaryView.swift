import SwiftUI
import SharedModels

/// フィルター情報表示
public struct FilterSummaryView: View {
    let filterCriteria: FilterCriteria
    let clearAction: () -> Void
    
    public init(filterCriteria: FilterCriteria, clearAction: @escaping () -> Void) {
        self.filterCriteria = filterCriteria
        self.clearAction = clearAction
    }
    
    public var body: some View {
        HStack {
            HStack(spacing: 8) {
                if let region = filterCriteria.region, !region.isEmpty {
                    FilterTag(text: region)
                }
                
                if filterCriteria.openOnly {
                    FilterTag(text: "営業中のみ")
                }
                
                if let maxWaitTime = filterCriteria.maxWaitTime {
                    FilterTag(text: "\(maxWaitTime)分以下")
                }
            }
            
            Spacer()
            
            Button("クリア", action: clearAction)
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 4)
    }
}

/// フィルタータグ
public struct FilterTag: View {
    let text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(12)
    }
}