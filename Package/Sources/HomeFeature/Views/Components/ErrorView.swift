import SwiftUI

/// エラー表示用のビュー
public struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    let dismissAction: () -> Void
    
    public init(
        message: String,
        retryAction: @escaping () -> Void,
        dismissAction: @escaping () -> Void
    ) {
        self.message = message
        self.retryAction = retryAction
        self.dismissAction = dismissAction
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("エラーが発生しました")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack(spacing: 12) {
                Button("再試行", action: retryAction)
                    .buttonStyle(.borderedProminent)
                
                Button("閉じる", action: dismissAction)
                    .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}