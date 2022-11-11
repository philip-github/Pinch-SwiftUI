//
//  ContentView.swift
//  Pinch
//
//  Created by Philip Al-Twal on 10/12/22.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    
    let pages: [Page] = pageData
    @State private var pageIndex: Int = 1
    
    // MARK: - FUNCTION
    private func resetImageState(){
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pageData[pageIndex - 1].imageName
    }
    
    // MARK: - CONTENT
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.clear
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(imageOffset)
                    .scaleEffect(imageScale)
                //MARK: 1- Tap Gesture
                    .onTapGesture(count: 2) {
                        withAnimation(.spring()) {
                            imageScale = imageScale == 1.0 ? 5.0 : 1.0
                            if imageScale == 1.0{
                                resetImageState()
                            }
                        }
                    }
                //MARK: 2- DRAG GESTURE
                    .gesture(
                        DragGesture()
                            .onChanged({ dragGesture in
                                withAnimation(.linear) {
                                    if abs(dragGesture.translation.width) <= 200 && abs(dragGesture.translation.height) <= 300{
                                        imageOffset = dragGesture.translation
                                    }
                                }
                            })
                            .onEnded({ _ in
                                if imageScale == 1{
                                    resetImageState()
                                }
                            })
                    )
                //MARK: 3- MAGNIFICATION GESTURE
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5{
                                        imageScale = value
                                    }else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            })
                            .onEnded({ _ in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }else if imageScale <= 1{
                                        resetImageState()
                                    }
                                }
                            })
                    )
            }//: ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            }
            //MARK: INFO PANEL
            .overlay(alignment: .top) {
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 0)
            }
            //MARK: CONTROLS
            .overlay(alignment: .bottom) {
                Group{
                    HStack{
                        // SCALE DOWN
                        Button{
                            withAnimation(.spring()) {
                                if imageScale > 1{
                                    imageScale -= 1
                                    
                                }
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                        }label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        // RESET
                        Button {
                            resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        // SCALE UP
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                }else if imageScale >= 5{
                                    imageScale = 5
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }//: CONTROLS END
                    .padding(EdgeInsets(top: 12,
                                        leading: 20,
                                        bottom: 12,
                                        trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                .padding(.bottom, 30)
            }
            //MARK: DRAWER
            .overlay(
                HStack(spacing: 12){
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture(count: 1, perform: {
                            withAnimation(.linear) {
                                isDrawerOpen.toggle()
                            }
                        })
                    //MARK: THUMBNAIL
                    ForEach(pages) { item in
                        Image(item.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = item.id
                            }
                    }
                    Spacer()
                }//: HSTACK
                    .padding(EdgeInsets(top: 16,
                                        leading: 7,
                                        bottom: 16,
                                        trailing: 7))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(maxWidth: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                ,alignment: .topTrailing
            )
        }//: NAVIGATION VIEW
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
