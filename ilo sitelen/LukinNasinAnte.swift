//
//  LukinNasinAnte.swift
//  ilo sitelen
//
//  Created by koteczek on 3/11/26.
//

import SwiftUI

struct LukinNasinAnte: View {
    @ObservedObject var dictManager: DictionaryManager
    @Binding var displayLanguage: DisplayLanguage
    @Binding var sitelenFont: SitelenFont
    @Binding var selection: Int
    @Binding var isDrawingMode: Bool
    
    @AppStorage("wakalito") var wakalito: Bool = true
    @Binding var showModelInput: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: dictManager.localizedText("nasin ante", "Options", lang: displayLanguage, font: sitelenFont)) {
                    Toggle(isOn: $wakalito) {
                        dictManager.localizedText("wakalito", "wakalito", lang: displayLanguage, font: sitelenFont)
                    }
                    Toggle(isOn: $showModelInput) {
                        dictManager.localizedText("lukin ilo lawa wan", "Show model input", lang: displayLanguage, font: sitelenFont)
                    }
                }
            }
            .navigationTitle(dictManager.localizedText("nasin ante", "Settings", lang: displayLanguage, font: sitelenFont))
            .toolbar {
                MainToolbar(selection: $selection, isDrawingMode: $isDrawingMode, sitelenFont: $sitelenFont, displayLanguage: $displayLanguage)
            }
        }
    }
}
