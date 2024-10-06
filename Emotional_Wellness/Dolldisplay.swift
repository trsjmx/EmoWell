import SwiftUI

struct Dolldisplay: View {
    private let numberOfStars = 20
    private let minStarDistance: CGFloat = 100.0 // Increase minimum distance between stars
    private let starPlacementRange: CGFloat = 200 // Range around the doll image
    private let starRegenerationInterval: Double = 2.0 // Time interval for regenerating stars

    @State private var starPositions: [CGSize] = []
    @State private var imageName: String = ""
    @State private var savedImageName: String? = nil
    @State private var timer: Timer? // Add a timer state

    var body: some View {
        ZStack {
            Color.cyan.opacity(0.2)
                .edgesIgnoringSafeArea(.all)

            // Stars surrounding the image
            ForEach(0..<starPositions.count, id: \.self) { index in
                StarShape()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.yellow.opacity(0.6))
                    .offset(x: starPositions[index].width, y: starPositions[index].height)
                    .opacity(1) // Always visible when present
            }

            VStack {
                Text("Here is your doll!")
                    .font(.largeTitle)
                    .padding(.top, 40)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()
                
                Image("dolll") // Replace with your actual image name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding(.top, 10)

                Spacer()

                VStack {
                    TextField("Enter doll Name", text: $imageName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(width: 250)
                        .background(Color.white)
                        .cornerRadius(8)

                    Button(action: {
                        savedImageName = imageName
                        imageName = ""
                    }) {
                        Text("Save doll Name")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 200)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.yellow]),
                                                       startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)

                    if let savedImageName = savedImageName {
                        Text("Saved doll Name: \(savedImageName)")
                            .padding()
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            generateStarPositions()
            startStarRegeneration()
        }
        .onDisappear {
            timer?.invalidate() // Invalidate the timer when the view disappears
        }
    }

    func generateStarPositions() {
        var positions: [CGSize] = []
        
        while positions.count < numberOfStars {
            // Generate random position around the image
            let newPosition = CGSize(
                width: CGFloat.random(in: -starPlacementRange...starPlacementRange),
                height: CGFloat.random(in: -starPlacementRange...starPlacementRange)
            )
            
            // Check if this new position is far enough from existing stars
            if positions.allSatisfy({ distance($0, newPosition) >= minStarDistance }) {
                positions.append(newPosition)
            }
        }
        
        starPositions = positions
    }

    func startStarRegeneration() {
        timer = Timer.scheduledTimer(withTimeInterval: starRegenerationInterval, repeats: true) { _ in
            withAnimation {
                starPositions.removeAll() // Fade out stars
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Wait a moment before regenerating
                generateStarPositions() // Generate new star positions
            }
        }
    }

    func distance(_ a: CGSize, _ b: CGSize) -> CGFloat {
        return sqrt(pow(a.width - b.width, 2) + pow(a.height - b.height, 2))
    }
}

struct starShape: Shape { // Correctly defined with uppercase "S"
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let points = [
            CGPoint(x: rect.width / 2, y: 0),
            CGPoint(x: rect.width, y: rect.height / 2),
            CGPoint(x: rect.width / 2, y: rect.height),
            CGPoint(x: 0, y: rect.height / 2)
        ]
        path.move(to: points[0])
        path.addLines(points)
        path.closeSubpath()
        return path
    }
}

#Preview {
    Dolldisplay()
}


