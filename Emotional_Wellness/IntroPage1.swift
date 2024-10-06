//
//  IntroPage1.swift
//  Emotional_Wellness
//
//  Created by Shahinaz Alsubaie on 29/03/1446 AH.
//

import SwiftUI

struct IntroPage1: View {
    // Number of clouds and their spacing
    private let numberOfClouds = 8
    private let minCloudDistance: CGFloat = 150.0 // Minimum distance between clouds
    
    @State private var cloudPositions: [CGSize] = []
    
    // State to track the selected image
    @State private var selectedImage: String? = nil
    
    var body: some View {
        NavigationView { // Wrap everything in NavigationView
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
                
                // Title, subtitle, and images in a vertical stack
                VStack {
                    // Enlarged text at the top of the screen
                    Text("I Feel You!")
                        .font(.system(size: 50)) // Increased size
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 50) // Add some padding from the top
                        .padding()
                    Text("Your mood now is")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                    
                    
                    // Images in a vertical stack with interaction
                    VStack(spacing: 20) { // Add spacing between the images
                        
                        NavigationLink(destination: ensuringUserEmotion()) {
                            moodImageView(imageName: "angry", selectedImage: $selectedImage)
                        }
                        
                        moodImageView(imageName: "sad", selectedImage: $selectedImage)
                        moodImageView(imageName: "vain", selectedImage: $selectedImage)
                        
                  

                            
                    }
                    
                    
                    Spacer() // Push content to the top
                }
                .padding(.horizontal, 20) // Add padding to the sides if needed
               
            }
            .onAppear {
                generateCloudPositions()
            }
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

struct moodImageView: View {
    let imageName: String
    @Binding var selectedImage: String?

    var body: some View {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 155, height: 155)
                .scaleEffect(selectedImage == imageName ? 1.2 : 1.0) // Image scaling effect
                .animation(.easeInOut(duration: 0.3), value: selectedImage) // Smooth animation
                
        }
}

#Preview {
    IntroPage1()
}
