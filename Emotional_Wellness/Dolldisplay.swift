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
    @State private var isReadyToStart: Bool = false

    var body: some View {
        
            ZStack {
                NavigationLink(destination: IntroPage1())  {}
                .navigationBarBackButtonHidden(true) // Hiding back button
                
                Color.cyan.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)

                ForEach(0..<starPositions.count, id: \.self) { index in
                    StarShape()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.white.opacity(0.6))
                        .offset(x: starPositions[index].width, y: starPositions[index].height)
                }

                VStack {
                    
                    // Confirmation Notification
                    if showConfirmation {
                        Text("name saved successfully")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                            .foregroundColor(.black.opacity(0.7))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.5))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.top,100)
                            .transition(.opacity)
                            .animation(.easeInOut, value: showConfirmation)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showConfirmation = false
                                    }
                                }
                            }
                    }

                    // Back Button
                    HStack {
                        NavigationLink(destination: ensuringUserEmotion()) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)


                                .font(.system(size:20, weight: .bold))

                                .font(.system(size: 13,weight: .bold))


                                .font(.system(size: 20, weight: .bold))

                                .padding()
                                .background(Color.yellow.opacity(0.8))
                                .clipShape(Circle())
                                .navigationBarBackButtonHidden(true) // Hiding back button
                        }
                       
                        Spacer()
                    }
                    .padding(.top, 40)
                    .padding(.leading, 20)

                    Text("Here is your doll!")
                        .font(.system(size: 35, weight: .bold, design: .rounded))
                        .padding(.top, 20)
                        .fontWeight(.bold)
                        .foregroundColor(.black.opacity(0.7))

                    // Display the saved name below the doll
                    if let name = savedImageName {
                        Text(name)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .padding(.top, 10)
                            .foregroundColor(.black.opacity(0.7))
                    }
                    Image("dolll") // Replace with your actual image name
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .padding(.top, 8)

                    

                    Spacer()

                    VStack (alignment: .center, spacing: (20)){
                        // Change Doll Name Text
                          Text("Give it a name!")
                              .font(.system(size: 30, weight: .bold, design: .rounded))
                              .foregroundColor(.black.opacity(0.7))

                          // TextField with Custom Styling
                          TextField("Enter your doll name", text: $imageName)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                              .padding() // Padding inside the text field
                              .frame(width:252,height: 50)
                              
                              .background(Color.white) // Background color
                              .cornerRadius(10) // Rounded corners
                              .shadow(radius: 3) // Optional: Add shadow
                            
                        // Button Row
                        HStack(spacing: 10) {
                            // Save Button
                            Button(action: {
                                saveName()
                            }) {
                                Text("Save")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 120)
                                    .background(.yellow.opacity(0.8))
                                    .cornerRadius(5)
                            }

                            // No Thanks Button
                            Button(action: {
                                savedImageName = nil // Clear the saved name
                                isReadyToStart = true // Show the start button
                                
                            }) {
                                Text("No Thanks")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 120)
                                    .background(Color.red.opacity(0.7))
                                    .cornerRadius(5)
                            }
                        }
                        .padding(.top, 10)

                        // Start Button
                        if isReadyToStart {
                            NavigationLink(destination: MainGameLogicPage(savedImageName: savedImageName)) {
                                Text("Start")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 120)
                                    .background(Color.blue.opacity(0.5))
                                    .cornerRadius(30)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.blue, lineWidth: 2)
                                    )
                                    .padding(.top, 20)
                            }
                        }
                    }
                    .padding(.bottom, 50)
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

    func saveName() {
        savedImageName = imageName // Update savedImageName with the user-entered name
        showConfirmation = true
        isReadyToStart = true
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
                Text(name) // Just show the name directly
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

