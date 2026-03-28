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
    
    @AppStorage("glassBlurRadius") private var glassBlurRadius: Double = 12.0
    @AppStorage("showFontNasin") private var showFontNasin = true
    @AppStorage("showFontLinja") private var showFontLinja = true
    @AppStorage("showFontTelo") private var showFontTelo = true
    @AppStorage("showFontSeli") private var showFontSeli = true
    @AppStorage("showFontFairfax") private var showFontFairfax = true
    @AppStorage("showFontLeko") private var showFontLeko = true
    @AppStorage("showFontFrt") private var showFontFrt = true
    
    @AppStorage("showLukaPona") private var showLukaPona = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: dictManager.localizedText("nasin ante", "Options", lang: displayLanguage, font: sitelenFont)) {
                    Toggle(isOn: $wakalito) {
                        dictManager.localizedText("ilo sitelen luka ilo Wakalito", "wakalito", lang: displayLanguage, font: sitelenFont)
                    }
                    Toggle(isOn: $showModelInput) {
                        dictManager.localizedText("sina wile ale wile lukin ilo lawa", "show glyph recognition model input", lang: displayLanguage, font: sitelenFont)
                    }
                    Toggle(isOn: $showLukaPona) {
                        dictManager.localizedText("sina wile ale wile lukin luka pona", "show luka pona", lang: displayLanguage, font: sitelenFont)
                    }
                }
                
                Section(header: Text("WordCard Settings")) {
                    VStack(alignment: .leading) {
                        Text("Background Blur Intensity")
                        Slider(value: $glassBlurRadius, in: 0...30, step: 1)
                    }
                    Toggle("nasin nanpa", isOn: $showFontNasin)
                    Toggle("linja sike", isOn: $showFontLinja)
                    Toggle("sitelen telo", isOn: $showFontTelo)
                    Toggle("sitelen seli kiwen", isOn: $showFontSeli)
                    Toggle("fairfax pona", isOn: $showFontFairfax)
                    Toggle("sitelen leko", isOn: $showFontLeko)
                    Toggle("してれん (frt)", isOn: $showFontFrt)
                }
            }
            .navigationTitle(dictManager.localizedText("nasin ante", "Settings", lang: displayLanguage, font: sitelenFont))
            .toolbar {
                MainToolbar(selection: $selection, isDrawingMode: $isDrawingMode, sitelenFont: $sitelenFont, displayLanguage: $displayLanguage)
            }
        }
    }
}
