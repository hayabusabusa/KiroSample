import SwiftUI

/// 最終更新時刻表示
public struct LastUpdatedView: View {
    let date: Date
    
    public init(date: Date) {
        self.date = date
    }
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
    
    public var body: some View {
        Text("最終更新: \(date, formatter: formatter)")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}