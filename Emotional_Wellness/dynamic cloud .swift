import SwiftUI

struct DynamicCloudView: View {
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
                    .offset(x: cloudPositions[index].width, y: cloudPositions[index].height)
                    .onAppear {
                        moveCloudUpwards(index: index)
                    }
            }
        }
        .onAppear {
            generateAndAnimateClouds()
        }
    }

    // Function to generate random cloud positions ensuring they are not too close to each other
    func generateCloudPositions() {
        var positions: [CGSize] = []
        
        while positions.count < numberOfClouds {
            let newPosition = CGSize(width: CGFloat.random(in: -200...200),
                                     height: CGFloat.random(in: 500...1000)) // Start clouds from below the screen
            
            // Check if the new position is far enough from existing clouds
            if positions.allSatisfy({ distance($0, newPosition) >= minCloudDistance }) {
                positions.append(newPosition)
            }
        }
        
        cloudPositions = positions
    }

    // Function to move clouds from the bottom upwards and then repeat the movement
    func moveCloudUpwards(index: Int) {
        var newPosition = cloudPositions[index]
        
        // Animate the cloud moving from the bottom to top
        withAnimation(Animation.linear(duration: Double.random(in: 3...5)).repeatForever(autoreverses: false)) {
            newPosition.height = -1000 // End position (off-screen above the view)
            cloudPositions[index] = newPosition
        }
    }

    // Generate and animate clouds in a loop
    func generateAndAnimateClouds() {
        generateCloudPositions()
        
        // Loop to keep generating clouds at different times
        for index in 0..<numberOfClouds {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.9) {
                moveCloudUpwards(index: index)
            }
        }
    }

    // Calculate the distance between two points (positions)
    func distance(_ a: CGSize, _ b: CGSize) -> CGFloat {
        return sqrt(pow(a.width - b.width, 2) + pow(a.height - b.height, 2))
    }
}

#Preview {
    DynamicCloudView()
}
