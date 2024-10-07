import SwiftUI

struct Dolldisplay: View {
    private let numberOfStars = 10
    private let minStarDistance: CGFloat = 100.0
    private let starPlacementRange: CGFloat = 200
    private let starRegenerationInterval: Double = 2.0

    @State private var starPositions: [CGSize] = []
    @State private var imageName: String = ""
    @State private var savedImageName: String? = nil
    @State private var timer: Timer?
    @State private var showConfirmation: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.cyan.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)

                ForEach(0..<starPositions.count, id: \.self) { index in
                    StarShape()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.white.opacity(0.6))
                        .offset(x: starPositions[index].width, y: starPositions[index].height)
                }

                VStack {
                    // Back Button
                    HStack {
                        NavigationLink(destination: ensuringUserEmotion()) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size:20, weight: .bold))
                                .padding()
                                .background(Color.yellow.opacity(0.8))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.top, 40)
                    .padding(.leading, 20)

                    Text("Here is your doll!")
                        .font(.largeTitle)
                        .padding(.top, 40)
                        .fontWeight(.bold)
                        .foregroundColor(.black.opacity(0.7))

                    Spacer()

                    Image("dolll") // Replace with your actual image name
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding(.top, 10)

                    Spacer()

                    VStack {
                        // Change Doll Name Text
                        Text("Change doll name?")
                            .font(.largeTitle)
                            .padding(.top, 40)
                            .fontWeight(.bold)
                            .foregroundColor(.black.opacity(0.7))

                        TextField("Enter doll Name", text: $imageName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .frame(width: 250)
                            .background(Color.white)
                            .cornerRadius(8)

                        // Button Row
                        HStack(spacing: 10) {
                            // Save Button
                            Button(action: {
                                saveName()
                            }) {
                                Text("Save")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 120)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.yellow]),
                                                               startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(5)
                            }

                            // No Thanks Button
                            NavigationLink(destination: ensuringUserEmotion()) {
                                Text("No Thanks")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 120)
                                    .background(Color.red.opacity(0.7))
                                    .cornerRadius(5)
                            }
                        }
                        .padding(.top, 10)

                        // Confirmation Message
                        if showConfirmation {
                            VStack {
                                Text("Saved Name \(savedImageName ?? "None")")
                                    .fontWeight(.bold)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.green.opacity(0.7)) // Adjusted opacity
                                    .cornerRadius(8)
                                    .padding(.top, 10)
                            }
                            .transition(.opacity) // Use opacity transition
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
                timer?.invalidate()
            }
        }
    }

    func saveName() {
        savedImageName = imageName
        showConfirmation = true
        
        // Hide confirmation after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showConfirmation = false
            }
        }
    }

    func generateStarPositions() {
        DispatchQueue.global(qos: .userInitiated).async {
            var positions: [CGSize] = []
            
            while positions.count < numberOfStars {
                let newPosition = CGSize(
                    width: CGFloat.random(in: -starPlacementRange...starPlacementRange),
                    height: CGFloat.random(in: -starPlacementRange...starPlacementRange)
                )
                
                if positions.allSatisfy({ distance($0, newPosition) >= minStarDistance }) {
                    positions.append(newPosition)
                }
            }
            
            DispatchQueue.main.async {
                starPositions = positions
            }
        }
    }

    func startStarRegeneration() {
        timer = Timer.scheduledTimer(withTimeInterval: starRegenerationInterval, repeats: true) { _ in
            withAnimation {
                starPositions.removeAll() // Fade out stars
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                generateStarPositions() // Generate new star positions
            }
        }
    }

    func distance(_ a: CGSize, _ b: CGSize) -> CGFloat {
        return sqrt(pow(a.width - b.width, 2) + pow(a.height - b.height, 2))
    }
}

struct starShape: Shape {
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

// New View for the Name Saved Page
struct NameSavedView: View {
    var savedName: String?

    var body: some View {
        VStack {
            Text("Name Saved!")
                .font(.largeTitle)
                .padding()
            if let name = savedName {
                Text("Saved doll Name: \(name)")
            } else {
                Text("No name was saved.")
            }
        }
        .font(.title)
        .padding()
    }
}

struct DollDisplay_Previews: PreviewProvider {
    static var previews: some View {
        Dolldisplay()
    }
}
