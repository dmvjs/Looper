import SwiftUI

struct BounceIntroView: View {
    let imageName: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
            Text("Welcome to Looper")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            Spacer()
            Button(action: onDismiss) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 50)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BounceIntroView_Previews: PreviewProvider {
    static var previews: some View {
        BounceIntroView(imageName: "bounce") {
            // Action on dismiss
        }
    }
}
