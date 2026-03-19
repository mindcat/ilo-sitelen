//
//  LukinSitelenAnte.swift
//  ilo sitelen
//
//  Created by koteczek on 3/11/26.
//

import SwiftUI

struct LukinSitelenAnte: View {
    @ObservedObject var dictManager: DictionaryManager
    @Binding var displayLanguage: DisplayLanguage
    @Binding var sitelenFont: SitelenFont
    @Binding var selection: Int
    @Binding var isDrawingMode: Bool
    
    @State private var playgroundText: String = "jan li pana e moku tawa sina. jan pali pi ma ale, o kama wan a!"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            dictManager.localizedText("ma sitelen", "Text Input", lang: displayLanguage, font: sitelenFont)
                                .font(.caption).foregroundStyle(.secondary)
                                .padding(.leading, 5)
                            
                            TextField("...", text: $playgroundText)
                                .textFieldStyle(.plain)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                                .autocorrectionDisabled()
                        }
                        .padding(.horizontal)
                        
                        Divider().padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            PreviewSection(title: "nasin nanpa", view: dictManager.tokiRenderer(playgroundText, lang: .tok, font: .nasin))
                            PreviewSection(title: "linja sike", view: dictManager.tokiRenderer(playgroundText, lang: .tok, font: .linja))
                            PreviewSection(title: "sitelen telo", view: dictManager.tokiRenderer(playgroundText, lang: .tok, font: .telo))
                            PreviewSection(title: "fairfax pona", view: dictManager.tokiRenderer(playgroundText, lang: .tok, font: .fairfax))
                            PreviewSection(title: "seli kiwen asuki", view: dictManager.tokiRenderer(playgroundText, lang: .tok, font: .seli))
                            PreviewSection(title: "sitelen leko", view: dictManager.tokiRenderer(playgroundText, lang: .tok, font: .leko))
                            PreviewSection(title: "F R T sitelen", view: dictManager.tokiRenderer(playgroundText, lang: .tok, font: .frt))
                            PreviewSection(title: "sitelen lasin lukin", view: dictManager.tokiRenderer(playgroundText, lang: .tok, font: .lasin))
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding(.top)
                }
            }
            .navigationTitle(dictManager.localizedText("sitelen ante", "Fonts", lang: displayLanguage, font: sitelenFont))
            .toolbar {
                MainToolbar(selection: $selection, isDrawingMode: $isDrawingMode, sitelenFont: $sitelenFont, displayLanguage: $displayLanguage)
            }
        }
    }
}

struct PreviewSection: View {
    let title: String
    let view: Text
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            
            view
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
