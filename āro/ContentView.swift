//
//  ContentView.swift
//  Browser
//
//  Created by Zachary Hixon on 1/13/22.
//

import Combine
import WebKit
import SwiftUI

struct ContentView: View {
    @StateObject var model = WebViewModel()
    @State var textFieldIsShowing: Bool = false
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .bottom) {
                
                VStack(spacing: 0) {
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.blue)
                        WebView(webView: model.webView)
                      //  Rectangle()
                        HStack(spacing: 10) {
                            if textFieldIsShowing{
                                HStack{
                            HStack {
                                VStack{
                                    TextField("",
                                              text: $model.urlString
                                              
                                    )
                                        .onSubmit {
                                            model.webView.reload()
                                            model.loadUrl()
                                            print(model.urlString)
                                        }
                                        .padding(10)
                                        .textFieldStyle(.roundedBorder)
                                    ProgressView(value: model.webView.estimatedProgress)

                                }
                                
                            }
                           
                            Button("Go", action: {
                                model.loadUrl()
                            })
                                .foregroundColor(.white)
                                .padding(10)
                            
                                .foregroundColor(.white)
                                .padding(.top)
                                }.background(RoundedRectangle(cornerRadius: 100).frame( alignment: .center).foregroundColor(.accentColor))
                                    .transition(.move(edge: .leading))
                                    .transition(.opacity)
                                    .animation(.spring())
                                 //   .animation(.spring())
                                    
                            }
                                
                            Circle()
                                .frame(width: 50, height: 50, alignment: .top)
                                .foregroundColor(.accentColor)
                                .padding(.top)
                        }
                        .transition(.slide)
                        .animation(.spring())
                        .transition(.slide)
                        .onHover{ over in
                            textFieldIsShowing = over
                        }
                        .transition(.slide)
                        .frame(width: geometry.size.width - 50, alignment: .topLeading)
                        .padding(.bottom, geometry.size.height)
                            
                        if model.isLoading {
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .onAppear {
                                    if model.webView.url?.absoluteString != model.urlString {
                                        model.urlString = model.webView.url!.absoluteString
                                    }
                                  
                                }
                            
                        }
                    }
                    
                }
            }
            
            /* .toolbar {
             ToolbarItemGroup() {
             Button(action: {
             model.goBack()
             }, label: {
             Image(systemName: "arrowshape.turn.up.backward")
             })
             .disabled(!model.canGoBack)
             
             Button(action: {
             model.goForward()
             }, label: {
             Image(systemName: "arrowshape.turn.up.right")
             })
             .disabled(!model.canGoForward)
             
             Spacer()
             }
             }*/
            
        }
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }}
