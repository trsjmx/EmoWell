//
//  LinkPages.swift
//  Emotional_Wellness
//
//  Created by Eng.Arwa on 06/04/1446 AH.
//

import SwiftUI

struct LinkPages: View {
    @State private var Transition: Bool = false
   
    var body: some View {
        VStack {

            
            if Transition == true {
                QuittingPage()
            }
            
            else {
                
                    EndPage()

            }
            
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                Transition = true
                                       }
    }
       
            
  }
                        
}
    
        
 
struct LinkPagesView_Previews: PreviewProvider {
    static var previews: some View {
        LinkPages()
    }
}
