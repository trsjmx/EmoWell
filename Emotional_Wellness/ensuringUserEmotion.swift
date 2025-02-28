//
//  IntroPage1.swift
//  Emotional_Wellness
//
//  Created by Eng.Arwa on 29/03/1446 AH.
import SwiftUI

struct ensuringUserEmotion: View {
    private let numberOfClouds = 8
    private let minCloudDistance: CGFloat = 150.0
    
    @State private var cloudPositions: [CGSize] = []
    @State private var beePosition: CGSize = CGSize(width: -300, height: 0)
    @State private var showQuestion = false
    @State private var showButtons = false // New state for button visibility
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
       
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
                    HStack {
                        NavigationLink(destination: IntroPage1()) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size:20, weight: .bold))
                                .padding()
                                .background(Color.yellow.opacity(0.8))
                                .clipShape(Circle())
                        }
                        .navigationBarBackButtonHidden(true) // Hiding back button
                        
                        Spacer()
                    }
                    .padding(.top, 40)
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    ZStack {
                        // Bee
                        Image("smile")
                            .resizable()
                            .frame(width: 200, height: 200) // Adjust this size to make the bee larger
                            .offset(beePosition)
                            .animation(.easeInOut(duration: 1.5), value: beePosition)
                        
                        if showQuestion {
                            SpeechBubbleView(text: "You seem angry today. Aren't you?")
                                .offset(x: beePosition.width + 135, y: beePosition.height - 70) // Adjusted offsets
                                .transition(.scale)
                        }
                        
                    }
                    
                    Spacer()
                    
                    // Buttons only appear after the bee and question bubble
                    if showButtons {
                        HStack(spacing: 10) {
                            
                            NavigationLink(destination: Dolldisplay()) {
                                Text("Yes")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 120)
                                    .background(Color.yellow.opacity(0.8))
                                    .cornerRadius(5)
                                    .navigationBarBackButtonHidden(true) // Hiding back button
                                
                            }
                            
                            
                            NavigationLink(destination: IntroPage1())  {
                                Text("No")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 120)
                                    .background(Color.red.opacity(0.8))
                                    .cornerRadius(5)
                            }
                        }
                        
                        .padding()
                        .padding(.bottom, 100)
                        .transition(.opacity) // Fade-in effect for buttons
                    }
                    
                }
            }
            
            .onAppear {
                generateCloudPositions()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    beePosition = CGSize(width: -50, height: 0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showQuestion = true
                        }
                        // Delay button appearance until after the question bubble
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showButtons = true
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
            ZStack {
                // Speech bubble shape
                SpeechBubbleShape()
                    .fill(Color.white)
                    .frame(width: 200, height: 100)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
                // Question text inside the bubble
                Text(text)
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .frame(width: 180) // Adjust width to fit the text
            }
            .frame(width: 200, height: 100)
            .padding(.leading, 20) // Adjust the padding to position better near the bee
        }
    }
    
    // Custom shape for the speech bubble with a little tail
    struct SpeechBubbleShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            let cornerRadius: CGFloat = 20
            
            // Draw the main bubble with rounded corners
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
            
            // Draw the tail of the speech bubble
            path.move(to: CGPoint(x: rect.width / 5, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width / 5 - 15, y: rect.height + 20))
            path.addLine(to: CGPoint(x: rect.width / 5 + 15, y: rect.height))
            
            return path
        }
    }
    
    struct BeeQuestionView_Previews: PreviewProvider {
        static var previews: some View {
            ensuringUserEmotion()
        }
    }

