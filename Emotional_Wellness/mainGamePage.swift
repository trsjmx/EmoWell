import SwiftUI
import AVFoundation // Import AVFoundation for audio playback

struct MainGameLogicPage: View {
    @State private var tapCount = 0
    
    
    @State private var showDoll2 = false
    @State private var showDoll3 = false
    @State private var showDoll4 = false
    @State private var showDoll5 = false
    @State private var showDoll6 = false
    @State private var showDoll7 = false
    
    @State private var showT2 = false // حالة t2
    @State private var showT3 = false // حالة t3
    @State private var showT4 = false // حالة t4
    // New state variable to trigger navigation to the EndPage
    @State private var navigateToEndPage = false
    
    private let numberOfClouds = 10
    private let cloudSpeed: Double = 10 // Speed of clouds moving
    private let groupSize = 3 // Number of clouds per group
    
    @State private var cloudPositions: [CGSize] = []
    @State private var cloudOffsets: [CGFloat] = []
    
    // Single audio player to reuse for all dolls
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        
        NavigationStack{
            ZStack {
                
                NavigationLink(destination: IntroPage1())  {}
                // Light blue sky background
                Color.cyan.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                    .navigationDestination(isPresented: $navigateToEndPage) {
                        LinkPages() // The page to navigate to
                    }
                
                
                // Clouds group - Fixed moderate size for all clouds
                ForEach(0..<cloudPositions.count, id: \.self) { index in
                    Image(systemName: "cloud.fill")
                        .resizable()
                        .frame(width: 120, height: 80) // Adjusted to a moderate size for all clouds
                        .foregroundColor(.white)
                        .offset(x: cloudPositions[index].width, y: cloudPositions[index].height + cloudOffsets[index])
                        .animation(
                            Animation.linear(duration: cloudSpeed)
                                .repeatForever(autoreverses: false),
                            value: cloudOffsets[index]
                        )
                }
                VStack{
                    // Add t1 image above the dolls
                    if tapCount <= 2  {
                        Image("t1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300) // Bigger size for t1
                            .offset(y: -250)
                            .onTapGesture {
                                withAnimation{
                                    tapCount += 1
                                    if tapCount >= 3 {
                                        playSound()
                                        showDoll2 = true
                                        showT2 = true
                                        
                                    }
                                }
                            }
                    }
                    if tapCount > 3 && tapCount <= 6 {
                        Image("t2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                            .offset(y: -250)
                            .onTapGesture {
                                withAnimation {
                                    tapCount += 1
                                    if tapCount >= 6{
                                        playSound()
                                        showT2 = true
                                        
                                    }
                                }
                            }
                    }
                    if  tapCount > 7 && tapCount <= 10{
                        Image("t3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                            .offset(y: -250)
                            .onTapGesture {
                                withAnimation{
                                    tapCount += 1
                                    if tapCount >= 9 {
                                        playSound()
                                        showT3 = true
                                        
                                    }
                                }
                            }
                    }
                    if tapCount > 11 && tapCount <= 14  {
                        Image("t4")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                            .offset(y: -250)
                            .onTapGesture {
                                withAnimation{
                                    tapCount += 1
                                    if tapCount >= 12{
                                        playSound()
                                        showT4 = true
                                        
                                    }
                                }
                            }
                    }
                    
                    
                    
                }
                .padding(.bottom,200)
                
                
                
                // Dolls with the same size, one on top of the other
                if !showDoll2 {
                    Image("doll1")
                        .resizable()
                        .frame(width: 250, height: 250) // Fixed size for all dolls
                        .onTapGesture {
                            withAnimation{
                                tapCount += 1
                                if tapCount <= 2 {
                                    playSound()
                                    showDoll2 = true
                                }
                            }
                        }
                }
                
                if showDoll2 && !showDoll3 {
                    Image("doll2")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .onTapGesture {
                            withAnimation{
                                tapCount += 1
                                if tapCount == 4 {
                                    playSound()
                                    showDoll3 = true
                                }
                            }
                        }
                }
                
                if showDoll3 && !showDoll4 {
                    Image("doll3")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .onTapGesture {
                            withAnimation{
                                tapCount += 1
                                if tapCount == 6 {
                                    playSound()
                                    showDoll4 = true
                                }
                                
                            }
                        }
                }
                
                if showDoll4 && !showDoll5 {
                    Image("doll4")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .onTapGesture {
                            withAnimation{
                                tapCount += 1
                                if tapCount == 8 {
                                    playSound()
                                    showDoll5 = true
                                }
                                
                            }
                        }
                }
                
                if showDoll5 && !showDoll6 {
                    Image("doll5")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .onTapGesture {
                            withAnimation{
                                tapCount += 1
                                if tapCount == 10 {
                                    playSound()
                                    showDoll6 = true
                                }
                            }
                        }
                }
                if showDoll6 && !showDoll7 {
                    Image("doll6")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .onTapGesture {
                            withAnimation{
                                tapCount += 1
                                if tapCount == 12 {
                                    playSound()
                                    showDoll7 = true
                                }
                            }
                        }
                }
                // Doll7 Logic - triggers navigation to EndPage
                if showDoll7 {
                    Image("doll7")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .onTapGesture {
                            tapCount += 1
                            if tapCount == 14 {
                                playSound()
                                // Navigate to EndPage when "doll7" is tapped
                                navigateToEndPage = true
                            }
                        }
                }
            }
            
        }
            .navigationBarBackButtonHidden(true) // Hiding back button
            .onAppear {
                setupCloudPositions()
                animateClouds()
            }
        
        
        }
        
        
        // Function to play the same sound for every doll
        func playSound() {
            guard let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") else { return }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    
        // Generate random cloud positions and initialize offsets for animation
        func setupCloudPositions() {
            var positions: [CGSize] = []
            var offsets: [CGFloat] = []
            
            let screenHeight = UIScreen.main.bounds.height
            let screenWidth = UIScreen.main.bounds.width
            
            for _ in 0..<numberOfClouds {
                let newPosition = CGSize(
                    width: CGFloat.random(in: -screenWidth / 4...screenWidth / 2),
                    height: CGFloat.random(in: screenHeight...screenHeight + 200)
                )
                positions.append(newPosition)
                offsets.append(0)
            }
            
            cloudPositions = positions
            cloudOffsets = offsets
        }
        
        // Animate the clouds by applying an upward movement and resetting when off-screen
        func animateClouds() {
            let screenHeight = UIScreen.main.bounds.height
            
            for i in 0..<numberOfClouds {
                let delay = Double(i % groupSize) * 0.5
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(Animation.linear(duration: cloudSpeed).repeatForever(autoreverses: false)) {
                        if i < cloudOffsets.count {
                            cloudOffsets[i] = -screenHeight - CGFloat(i * 500)
                        }
                    }
                }
            }
        }
    }

#Preview {
    MainGameLogicPage()
}

