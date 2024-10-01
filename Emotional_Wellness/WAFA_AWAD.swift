//
//  WAFA_AWAD.swift
//  Emotional_Wellness
//
//  Created by Wafa Awad  on 28/03/1446 AH.
//

import SwiftUI

struct WAFA_AWAD: View {
    @State private var isAnimating = false
    var body: some View {
        
        ZStack{
            Color.lightBlue.ignoresSafeArea()
            
            VStack{
                Image("bee_1")
                    .font(.largeTitle)
                    .foregroundColor(.lightBlue)
                //.resizable()
                    .scaledToFit()
                    .scaleEffect(isAnimating ? 1.5 : 1.0)
                    .onAppear() {
                        
                        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            isAnimating = true
                        }
                        // Image(.rectangle)
                        // VStack{
                        // Image("Untitled_design-removebg-preview3")
                        //.
                        //    }
                        
                        
                        
                    }
            }
        }
    }
}

#Preview {
    WAFA_AWAD()
}
