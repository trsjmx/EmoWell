import SwiftUI

struct dollView: View {
    // Number of stars and their spacing
    private let numberOfStars = 20 // Number of stars
    private let minStarDistance: CGFloat = 50.0  // Closer spacing between stars
    private let animationDuration: Double = 6.0  // Fixed constant animation duration for uniform speed
    
    @State private var starPositions: [CGSize] = []

    var body: some View {
        ZStack {
            // Light purple sky background
            Color.lightBlue.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            // Stars positioned randomly but not too close to each other
            ForEach(0..<starPositions.count, id: \.self) { index in
                StarShape()
                    .frame(width: 50, height: 50) // Bigger stars with fixed size
                    .foregroundColor(.lightBlue) // Yellow color for the stars
                    .offset(x: starPositions[index].width, y: starPositions[index].height)
                    .onAppear {
                        moveStarHorizontally(index: index)
                    }
            }
        }
        .onAppear {
            generateAndAnimateStars()
        }
    }

    // Function to generate random star positions ensuring they are not too close to each other
    func generateStarPositions() {
        var positions: [CGSize] = []
        
        while positions.count < numberOfStars {
            let newPosition = CGSize(width: CGFloat.random(in: -200...300), // Random x-range for stars
                                     height: CGFloat.random(in: -400...500)) // Random y-range for stars
            
            // Check if the new position is far enough from existing stars
            if positions.allSatisfy({ distance($0, newPosition) >= minStarDistance }) {
                positions.append(newPosition)
            }
        }
        
        starPositions = positions
    }

    // Function to move stars horizontally from left to right and then repeat the movement
    func moveStarHorizontally(index: Int) {
        var newPosition = starPositions[index]
        
        // Animate the star moving from left to right with a fixed duration for uniform speed
        withAnimation(Animation.linear(duration: animationDuration) // Fixed duration for consistent speed
                        .repeatForever(autoreverses: false)) {
            newPosition.width = 1200 // End position for stars to move off-screen
            starPositions[index] = newPosition
        }
        
        // Add a new star immediately when the current star moves off-screen
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            regenerateStar(index: index)
        }
    }

    // Function to regenerate a star once it's moved off the screen
    func regenerateStar(index: Int) {
        var newPosition = starPositions[index]
        newPosition.width = -50 // Reset the star to the left side of the screen
        newPosition.height = CGFloat.random(in: -50...100) // Randomize y-position
        
        // Update the position of the star
        starPositions[index] = newPosition
        
        // Start the movement again
        moveStarHorizontally(index: index)
    }

    // Generate and animate stars in a loop
    func generateAndAnimateStars() {
        generateStarPositions()
        
        // Loop to keep generating stars at different times, adding more at the start
        for index in 0..<numberOfStars {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) { // Spacing out the start times slightly
                moveStarHorizontally(index: index)
            }
        }
    }

    // Calculate the distance between two points (positions)
    func distance(_ a: CGSize, _ b: CGSize) -> CGFloat {
        return sqrt(pow(a.width - b.width, 2) + pow(a.height - b.height, 2))
    }
}

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height
        
        // Create a diamond-like star by defining points
        let points = [
            CGPoint(x: width / 2, y: 0),  // Top
            CGPoint(x: width, y: height / 2),  // Right
            CGPoint(x: width / 2, y: height),  // Bottom
            CGPoint(x: 0, y: height / 2),  // Left
        ]
        
        // Draw the path connecting the points in a diamond shape
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addLine(to: points[2])
        path.addLine(to: points[3])
        path.closeSubpath()

        return path
    }
}

#Preview {
    dollView()
}
