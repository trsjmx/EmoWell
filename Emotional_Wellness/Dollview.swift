import SwiftUI

struct DollView: View {
    private let numberOfStars = 20
    private let minStarDistance: CGFloat = 50.0
    private let animationDuration: Double = 6.0
    
    @State private var starPositions: [CGSize] = []
    @State private var imageName: String = ""
    @State private var savedImageName: String? = nil

    var body: some View {
        ZStack {
            Color.cyan.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            ForEach(0..<starPositions.count, id: \.self) { index in
                StarShape()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.yellow.opacity(0.2))
                    .offset(x: starPositions[index].width, y: starPositions[index].height)
                    .onAppear {
                        moveStarHorizontally(index: index)
                    }
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
            generateAndAnimateStars()
        }
    }

    func generateStarPositions() {
        var positions: [CGSize] = []
        
        while positions.count < numberOfStars {
            let newPosition = CGSize(width: CGFloat.random(in: -200...300),
                                     height: CGFloat.random(in: -400...500))
            if positions.allSatisfy({ distance($0, newPosition) >= minStarDistance }) {
                positions.append(newPosition)
            }
        }
        
        starPositions = positions
    }

    func moveStarHorizontally(index: Int) {
        var newPosition = starPositions[index]
        
        withAnimation(Animation.linear(duration: animationDuration)
                        .repeatForever(autoreverses: false)) {
            newPosition.width = 1200
            starPositions[index] = newPosition
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            regenerateStar(index: index)
        }
    }

    func regenerateStar(index: Int) {
        var newPosition = starPositions[index]
        newPosition.width = -50
        newPosition.height = CGFloat.random(in: -900...900)
        
        starPositions[index] = newPosition
        moveStarHorizontally(index: index)
    }

    func generateAndAnimateStars() {
        generateStarPositions()
        
        for index in 0..<numberOfStars {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                moveStarHorizontally(index: index)
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

#Preview {
    DollView()
}
