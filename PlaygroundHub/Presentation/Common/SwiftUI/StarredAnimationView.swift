//
//  StarredAnimationView.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2022/01/09.
//

import SwiftUI

struct StarredAnimationView: View {
    var isStarred: Bool
    
    var starredText: some View {
        Text(isStarred ? "Starred" : "Unstarred")
            .font(Font.body.bold())
            .multilineTextAlignment(.center)
    }
    
    var body: some View {
        VStack{
            Spacer()
            VStack(spacing: 24){
                AnimatedCheckmarkView(color: isStarred ? .yellow : .black)
                starredText
            }
            .frame(width: 120, height: 120, alignment: .center)
            .padding()
            .background(BlurView())
            .cornerRadius(20)
            Spacer()
        }
    }
}

struct StarredAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        StarredAnimationView(isStarred: false)
    }
}
