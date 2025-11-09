import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // App icon or logo can go here
                Image(systemName: "book.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                ProgressView()
                    .scaleEffect(1.5)
                    .padding(.top, 20)
                
                Text("Loading...")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
            }
        }
    }
}

#Preview {
    SplashView()
}

