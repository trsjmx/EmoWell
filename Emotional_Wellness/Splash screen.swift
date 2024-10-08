//
//  Splash_screen.swift
//  Emotional_Wellness
//
//  Created by Eng.Arwa on 05/04/1446 AH.
//

import SwiftUI

struct Splash_screen: View {
    // State to control navigation
    @State private var isActive = false
    @State private var fadeInOut = false // For animation effect
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Light cyan background
                Color.cyan.opacity(0.2)
                    .edgesIgnoringSafeArea(.all) // Ensures the color covers the entire screen
                
                VStack {
                    // Icon in the center
                    Image("oh")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150) // Adjust icon size
                        .opacity(fadeInOut ? 1 : 0) // Fade in effect
                    
                    // Text below the icon
                    Text("Emotional Wellness")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .opacity(fadeInOut ? 1 : 0) // Fade in effect
                }
                .onAppear {
                    // Trigger the fade in animation
                    withAnimation(.easeIn(duration: 2)) {
                        fadeInOut = true
                    }
                    
                    // Automatically navigate to the next page after 3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeInOut) {
                            isActive = true
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $isActive) {
                IntroPage1() // Your intro page
                    .transition(.slide) // Add a slide transition effect
            }
        }
        .navigationBarHidden(true) // Hide the navigation bar on the splash screen
    }
}

#Preview {
    Splash_screen()
}
