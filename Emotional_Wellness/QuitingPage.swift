import SwiftUI

struct QuittingPage: View {
    private let numberOfClouds = 8
    private let minCloudDistance: CGFloat = 150.0
    
    @State private var cloudPositions: [CGSize] = []
    @State private var beePosition: CGSize = CGSize(width: -300, height: 0)
    @State private var showQuestion = false
    @State private var rating: Int = 0 // Initialize the rating
    @State private var showRatingView = false // State variable for rating view visibility
    
    var body: some View {
        NavigationView {
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
                    
                    VStack {
                        HStack{
                            NavigationLink {
                                IntroPage1()
                                    .navigationBarBackButtonHidden(true) // Hiding back button
                            } label: {
                                Image(systemName: "house")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .padding(10)
                                    .foregroundColor(.white.opacity(0.8
                                                                   ))
                                    .background(Color.yellow.opacity(0.8))
                                    .clipShape(Circle())
                                    .font(.system(size:13 , weight: .bold))
                            }
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.leading, 20)
                        Spacer()
                        
    
                        ZStack {
                            // Bee
                            Image("smile")
                                .resizable()
                                .frame(width: 200, height: 200)
                                .offset(beePosition)
                                .animation(.easeInOut(duration: 3), value: beePosition)
                            
                            if showQuestion {
                                TextBubbleView(text: "Have a good day XOXO")
                                    .offset(x: beePosition.width + 135, y: beePosition.height - 70)
                                    .transition(.scale)
                            }
                        }
                        .padding(.bottom, 100)
                        .transition(.opacity)
                        
                        // Rating View
                        if showRatingView {
                            HStack {
                                RatingView(rating: $rating)
                                
                                    .padding(.top, 40)
                                    .transition(.scale) // Use scale transition for animation
                            }
                        }
                    }
                    Spacer()
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
                    // Show the rating view after 5 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            showRatingView = true // Trigger rating view visibility
                               // .cornerRadius(10)
                              
                        }
                      
                        
                    }
                    
                }
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
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

struct TextBubbleView: View {
    let text: String
    
    var body: some View {
        ZStack {
            TextBubbleShape()
                .fill(Color.white)
                .frame(width: 200, height: 100)
            
            Text(text)
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
                .frame(width: 180)
        }
        .padding(.leading, 20)
    }
}

struct TextBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerRadius: CGFloat = 20

        path.move(to: CGPoint(x: cornerRadius, y: 0))
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
                    radius: cornerRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius),
                    radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
                    radius: cornerRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                    radius: cornerRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        path.move(to: CGPoint(x: rect.width / 5, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width / 5 - 15, y: rect.height + 20))
        path.addLine(to: CGPoint(x: rect.width / 5 + 15, y: rect.height))

        return path
    }
}

// Star View
struct StarView: View {
    var isFilled: Bool
    @State private var scale: CGFloat = 1.0 // Scale for animation
    @State private var isFavorite = false

    var body: some View {
      
        Image(systemName: isFilled ? "star.fill" : "star")
        
            .resizable()
    
            .aspectRatio(contentMode: .fit)
       
            .foregroundColor(isFilled ? .yellow : .gray.opacity(0.3))
            
            .frame(width: 40, height: 40)
            .scaleEffect(scale) // Apply scale effect
            .symbolEffect(.bounce.down, value: isFavorite)
            
    }
    
}


// Rating View
struct RatingView: View {
    @Binding var rating: Int
    let maxRating: Int = 5
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
              //.border(.gray, width: 0.5)
                .shadow(radius: 3)
                .frame(width: 300, height: 50)
            HStack {
                
                ForEach(0..<maxRating, id: \.self) { index in
                    StarView(isFilled: index < rating)
                        .onTapGesture {
                            rating = index + 1
                        }
                }
        }
        
            .cornerRadius(12)
        }
        .padding(.bottom,150)
      
        
    }
    
}

// Preview
struct QuittingPage_Previews: PreviewProvider {
    static var previews: some View {
        QuittingPage()
    }
}

