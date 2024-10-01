import SwiftUI

struct IntroPage2: View {
    // Number of clouds and their spacing
    private let numberOfClouds = 8
    private let minCloudDistance: CGFloat = 150.0 // Minimum distance between clouds
    
    @State private var cloudPositions: [CGSize] = []
    
    var body: some View {
        ZStack {
            // Light blue sky background
            Color.cyan.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            // Clouds positioned randomly but not too close to each other
            ForEach(0..<cloudPositions.count, id: \.self) { index in
                Image(systemName: "cloud.fill")
                    .resizable()
                    .frame(width: CGFloat.random(in: 100...200), height: CGFloat.random(in: 60...120))
                    .foregroundColor(.white)
                    .offset(cloudPositions[index])
            }
        }
        .onAppear {
            generateCloudPositions()
        }
    }
    
    // Generate random cloud positions ensuring they are not too close to each other
    func generateCloudPositions() {
        var positions: [CGSize] = []
        
        while positions.count < numberOfClouds {
            let newPosition = CGSize(width: CGFloat.random(in: -200...200),
                                     height: CGFloat.random(in: -400...400))
            
            // Check if the new position is far enough from existing clouds
            if positions.allSatisfy({ distance($0, newPosition) >= minCloudDistance }) {
                positions.append(newPosition)
            }
        }
        
        cloudPositions = positions
    }
    
    // Calculate the distance between two points (positions)
    func distance(_ a: CGSize, _ b: CGSize) -> CGFloat {
        return sqrt(pow(a.width - b.width, 2) + pow(a.height - b.height, 2))
    }
}

#Preview {
    IntroPage2()
}
