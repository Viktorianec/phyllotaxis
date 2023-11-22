//
//  Home.swift
//  Animation
//
//  Created by Viktorianec on 23.08.2022.
//

import SwiftUI

struct Home: View {
    
    @GestureState var location:CGPoint = .zero
    var body: some View {
        GeometryReader{proxy in
            let size = proxy.size
            // to fit into whole view
            let width = size.width/10
            let itemCount = Int((size.height / width).rounded()) * 10
            LinearGradient(colors: [.cyan, .yellow, .mint, .pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .mask {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 10), spacing: 0) {
                        ForEach(0..<itemCount, id: \.self) {_ in
                            GeometryReader{ innerProxy in
                                let rect = innerProxy.frame(in: .named("GESTURE"))
                                let scale = itemScale(rect: rect, size: size)
                                
                                let trasnformedRect = rect.applying(.init(scaleX: scale, y: scale))
                                
                                let transformedLocation = location.applying(.init(scaleX: scale, y: scale))
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.orange)
                                    .scaleEffect(scale)
                                    .offset(x: trasnformedRect.midX - rect.midX, y: trasnformedRect.midY - rect.midY)
                                    .offset(x: location.x - transformedLocation.x, y: location.y - transformedLocation.y)
                            }
                            .padding(5)
                            .frame(height:width)
                        }
                    }
                }

        }
        .padding(15)
        .gesture(DragGesture(minimumDistance: 0)
            .updating($location, body: { value, out, _ in
                out = value.location
            }))
        .coordinateSpace(name: "GESTURE")
        .preferredColorScheme(.dark)
        .animation(.easeInOut, value: location == .zero)
    }
    
    func itemScale(rect: CGRect, size:CGSize) -> CGFloat {
        let a = location.x - rect.midX
        let b = location.y - rect.midY
        
        let root = sqrt(a*a + b*b)
        let diagonalValue = sqrt(size.width * size.width + size.height * size.height)
        let scale = root / (diagonalValue / 2)
        let modifiedScale = location == .zero ? 1 : (1 - scale)
        return modifiedScale > 0 ? modifiedScale : 0.001
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
