import SwiftUI
import SharedModels

/// 店舗行表示
public struct StoreRowView: View {
    let store: Store
    let refreshAction: () -> Void
    
    public init(store: Store, refreshAction: @escaping () -> Void) {
        self.store = store
        self.refreshAction = refreshAction
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.name)
                        .font(.headline)
                    
                    Text(store.address)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    WaitTimeView(waitTime: store.waitTime)
                    
                    Button {
                        refreshAction()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}