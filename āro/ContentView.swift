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
    
    var body: some View {
        GeometryReader { geometry in

        ZStack(alignment: .bottom) {
            
            VStack(spacing: 0) {
       /*         HStack(spacing: 10) {
                    HStack {
                        VStack{
                        TextField("Tap an url",
                                  text: $model.urlString
    
                                  )
                                .onAppear(perform: {

                                })
                           
                            .padding(10)
                                }
                        
                    }
                    .background(Color.white)
                    .cornerRadius(30)
                    
                    Button("Go", action: {
                        model.loadUrl()
                    })
                    .foregroundColor(.white)
                    .padding(10)
                    Button("Go", action: {
                    //    model.loadUrl()
                        if model.webView.url?.absoluteString != model.urlString {
                            model.urlString = model.webView.url!.absoluteString
                        }
                    })
                        .foregroundColor(.white)
                        .padding(10)
                }.padding(10)*/
                
                ZStack {
                    WebView(webView: model.webView)
                    HStack(spacing: 10) {
                        HStack {
                            VStack{
                            TextField("Tap an url",
                                      text: $model.urlString
        
                                      )
                                    .onSubmit {
                                        model.loadUrl()
                                    }
                                .padding(10)
                                    }
                            
                        }
                        .background(Color.white)
                        .cornerRadius(30)
                        
                        Button("Go", action: {
                            model.loadUrl()
                        })
                        .foregroundColor(.white)
                        .padding(10)
                     
                            .foregroundColor(.white)
                            .padding(.top)
                    }.padding(.bottom, geometry.size.height)
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
