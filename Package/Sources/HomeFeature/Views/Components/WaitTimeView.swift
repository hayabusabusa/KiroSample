import SwiftUI
import SharedModels

/// 待ち時間表示
public struct WaitTimeView: View {
    let waitTime: WaitTime
    
    public init(waitTime: WaitTime) {
        self.waitTime = waitTime
    }
    
    public var body: some View {
        Group {
            switch waitTime.status {
            case .available:
                if let minutes = waitTime.minutes {
                    Text("\(minutes)分待ち")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(waitTime.colorCode)
                } else {
                    Text("待ち時間不明")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            case .closed:
                Text("営業時間外")
                    .font(.caption)
                    .foregroundColor(.secondary)
            case .unavailable:
                Text("データ取得不可")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}