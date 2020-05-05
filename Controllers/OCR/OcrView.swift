//
//  OcrView.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 5/5/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import SwiftUI

struct OcrView: View {
    
    @ObservedObject var manager: OcrService
    
    var body: some View {
        ZStack {
            OcrSUIView(manager: manager)
            VStack {
                HStack{
                    Spacer()
                    Text(manager.isMyanmar ? "Myanmar" : "English")
                        .onTapGesture {
                            self.manager.toggleIsMyanmar()
                    }
                }
                Spacer()
                HStack{
                    Button(action: {
                        self.manager.capture()
                    }) {
                        Image(systemName: "circle.fill")
                        .resizable()
                    }
                    .frame(width: 65, height: 65)
                }
                .padding(.bottom)
            }
            .padding()
        }
        .accentColor(.white)
        .foregroundColor(.white)
        .onAppear {
            self.manager.didAppear()
        }
    }
}

class OcrViewController: UIHostingController<OcrView> {
    let manager = OcrService()
    init(){
        super.init(rootView: OcrView(manager: manager))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


struct OcrSUIView: UIViewRepresentable {

    let manager: OcrService

    func makeUIView(context: Context) -> CameraView {
        return manager.cameraView
    }

    func updateUIView(_ uiView: CameraView, context: Context) {
        
    }
}
