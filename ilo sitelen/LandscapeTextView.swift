//
//  LandscapeTextView.swift
//  ilo sitelen
//
//  Created by koteczek on 3/12/26.
//

import SwiftUI

struct LandscapeTextView: View {
    let text: String
    let isTokiPona: Bool
    @ObservedObject var dictManager: DictionaryManager
    let displayLanguage: DisplayLanguage
    let sitelenFont: SitelenFont
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(UIColor.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(32)
                    
                    Spacer()
                    
                    ScrollView(showsIndicators: false) {
                        if isTokiPona {
                            dictManager.tokiRenderer(text, lang: displayLanguage, font: sitelenFont, fontSize: 80)
                                .foregroundColor(.cyan)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        } else {
                            Text(text)
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.cyan)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // whisper model or something??? idek. i might look for spanish models and see if i can trick them to sound toki pona
                    }) {
                        Image(systemName: "speaker.wave.2.circle.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.cyan)
                    }
                    .padding(.bottom, 32)
                }
                .frame(width: geometry.size.height, height: geometry.size.width)
                .rotationEffect(.degrees(90))
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}
