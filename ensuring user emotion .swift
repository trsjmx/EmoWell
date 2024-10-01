import SwiftUI

struct BeeQuestionView: View {
    private let numberOfClouds = 8
    private let minCloudDistance: CGFloat = 150.0
    
    @State private var cloudPositions: [CGSize] = []
    @State private var beePosition: CGSize = CGSize(width: -300, height: 0)
    @State private var showQuestion = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.cyan.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                ForEach(0..<cloudPositions.count, id: \.self) { index in
                    Image(systemName: "cloud.fill")
                        .resizable()
                        .frame(width: CGFloat.random(in: 100...200), height: CGFloat.random(in: 60...120))
                        .foregroundColor(.white)
                        .offset(cloudPositions[index])
                }
                
                //Bee
                Image("bee")
                
                    .frame(width: 100, height: 100)
                    .offset(beePosition)
                    .animation(.easeInOut(duration: 3), value: beePosition)
                
                if showQuestion {
                    SpeechBubbleView(text: "You seem angry today. Are you not?")
                        .offset(x: beePosition.width + 120, y: beePosition.height - 50)
                        .transition(.scale)
                   
                }
            }
            .onAppear {
                generateCloudPositions()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    beePosition = CGSize(width: -50, height: 0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showQuestion = true
                        }
                    }
                }
            }
        }
    }
    
    func generateCloudPositions() {
        var positions: [CGSize] = []
        
        while positions.count < numberOfClouds {
            let newPosition = CGSize(width: CGFloat.random(in: -200...200),
                                     height: CGFloat.random(in: -400...400))
            
            if positions.allSatisfy({ distance($0, newPosition) >= minCloudDistance }) {
                positions.append(newPosition)
            }
        }
        
        cloudPositions = positions
    }
    
    func distance(_ a: CGSize, _ b: CGSize) -> CGFloat {
        return sqrt(pow(a.width - b.width, 2) + pow(a.height - b.height, 2))
    }
}



struct SpeechBubbleView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .padding()
            .background(
                Path { path in
                    let width: CGFloat = 200
                    let height: CGFloat = 100
                    let cornerRadius: CGFloat = 20
                    
                    path.move(to: CGPoint(x: cornerRadius, y: 0))
                    path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
                    path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                    path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
                    path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                    path.addLine(to: CGPoint(x: cornerRadius, y: height))
                    path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                    path.addLine(to: CGPoint(x: 0, y: cornerRadius))
                    path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                    path.closeSubpath()
                    
                    path.move(to: CGPoint(x: 0, y: height / 2))
                    path.addLine(to: CGPoint(x: -20, y: height / 2 + 20))
                    path.addLine(to: CGPoint(x: 0, y: height / 2 + 20))
                }
                    .fill(Color.red.opacity(0.5))
            )
            .frame(width: 200, height: 100)
    }
}

struct BeeQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        BeeQuestionView()
    }
}
