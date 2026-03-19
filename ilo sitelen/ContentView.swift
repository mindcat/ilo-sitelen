//
//  ContentView.swift
//  ilo sitelen
//
//  Created by koteczek on 2/11/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dictManager = DictionaryManager()
    @StateObject private var drawingProcessor = DrawingProcessor()
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var displayLanguage: DisplayLanguage = .tok
    @State private var sitelenFont: SitelenFont = .nasin
    @State private var selection: Int = 0
    @State private var isDrawingMode: Bool = false
    @State private var showModelInput: Bool = false

    var body: some View {
        TabView(selection: $selection) {
            
            Tab(value: 0) {
                LukinTokiAnte(
                    dictManager: dictManager,
                    displayLanguage: $displayLanguage,
                    sitelenFont: $sitelenFont,
                    isDrawingMode: $isDrawingMode,
                    selection: $selection)
            } label: {
                Label(
                    title: { dictManager.localizedText("ilo toki ante", "Translator", lang: displayLanguage, font: sitelenFont) },
                    icon: { colorScheme == .dark ? Image("tp_translate.dark") : Image("tp_translate") }
                )
            }

            Tab(value: 1) {
                LukinLipuNimi(
                    dictManager: dictManager,
                    drawingProcessor: drawingProcessor,
                    displayLanguage: $displayLanguage,
                    sitelenFont: $sitelenFont,
                    isDrawingMode: $isDrawingMode,
                    showModelInput: $showModelInput,
                    selection: $selection
                )
            } label: {
                Label(
                    title: { dictManager.localizedText("lipu nimi", "Dictionary", lang: displayLanguage, font: sitelenFont) },
                    icon: { colorScheme == .dark ? Image("tp_dict.dark") : Image("tp_dict") }
                )
            }

            TabSection("More Options") {
                
                Tab(value: 2) {
                    LukinSitelenAnte(
                        dictManager: dictManager,
                        displayLanguage: $displayLanguage,
                        sitelenFont: $sitelenFont,
                        selection: $selection,
                        isDrawingMode: $isDrawingMode
                    )
                } label: {
                    Label(
                        title: { dictManager.localizedText("sona linluwi", "Learn More", lang: displayLanguage, font: sitelenFont) },
                        icon: { colorScheme == .dark ? Image("sona-linluwi.dark") : Image("sona-linluwi") }
                    )
                }
                
                Tab(value: 3) {
                    LukinNasinAnte(
                        dictManager: dictManager,
                        displayLanguage: $displayLanguage,
                        sitelenFont: $sitelenFont,
                        selection: $selection,
                        isDrawingMode: $isDrawingMode,
                        showModelInput: $showModelInput
                    )
                } label: {
                    Label(
                        title: { dictManager.localizedText("nasin ante", "Settings", lang: displayLanguage, font: sitelenFont) },
                        icon: { colorScheme == .dark ? Image("nasin-ante.dark") : Image("nasin-ante") }
                    )
                }
            }
        }
    }
}
