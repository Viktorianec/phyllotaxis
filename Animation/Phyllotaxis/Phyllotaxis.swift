//
//  Phyllotaxis.swift
//  Animation
//
//  Created by iOS Dev on 23.08.2022.
//

import SwiftUI

struct Phyllotaxis: View {
    
    let initialScale = 0.1
    let angleRadiansToPlay:Double = 0.75
    let totalCountCircles:Int = 300
    let maxWidth:Double = 10
    
    @State private var currentScale = 0.1
    @State private var rotationAngle:Double = 0
    @State private var closed = true
    
    var body: some View {
        LinearGradient(colors: [.cyan, .yellow, .mint, .pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            .mask {
            GeometryReader{proxy in
                let size = proxy.size
                let xCenter = size.width / 2
                let yCenter = size.height / 2
                
                ForEach(0 ..< totalCountCircles, id: \.self) { i in
                    let radius:Double = maxWidth * sqrt(Double(i))
                    let angle:Double = Double(i) * angleRadiansToPlay
                    let x:Double = radius * cos(angle) + xCenter
                    let y:Double = radius * sin(angle) + yCenter
                    
                    let width = CGFloat(i)/CGFloat(totalCountCircles) * maxWidth
                   
                    CircleInside(i: i, x: x, y: y, width: width, totalCount: totalCountCircles, closed:closed)
                }
            }
            .scaleEffect(x: currentScale, y: currentScale)
            .rotationEffect(.degrees(rotationAngle))
        }
        .onTapGesture(count: 1) {
            withAnimation(.easeOut(duration: 0.5)) {
                    currentScale = !closed ? initialScale : 0.8
                    rotationAngle = closed ? 90 : 0
                    closed = !closed
                }
            }
        .preferredColorScheme(.dark)
    }
    
}

struct CircleInside: View {
    
    var i: Int
    var x:CGFloat
    var y:CGFloat
    var width:CGFloat
    var totalCount:Int
    var closed:Bool
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: width/2, style: .circular)
            .frame(width: width, height: width, alignment: .center)
            .offset(x: x, y: y)
        
    }
}

struct Phyllotaxis_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
