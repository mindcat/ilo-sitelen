//
//  MainToolbar.swift
//  ilo sitelen
//
//  Created by koteczek on 3/11/26.
//

import SwiftUI

struct MainToolbar: ToolbarContent {
    @Binding var selection: Int
    @Binding var isDrawingMode: Bool
    @Binding var sitelenFont: SitelenFont
    @Binding var displayLanguage: DisplayLanguage
    @Environment(\.colorScheme) var colorScheme

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 16) {
                if selection == 0 {
                    Button(action: {
                    }) {
                        Image(systemName: "camera")
                            .foregroundColor(.primary)
                    }
                }
                
                if selection == 1 {
                    Button(action: {
                        withAnimation { isDrawingMode.toggle() }
                    }) {
                        Image(systemName: "scribble.variable")
                            .foregroundColor(isDrawingMode ? .blue : .primary)
                    }
                }
                
                Menu {
                    Picker("Sitelen Font", selection: $sitelenFont) {
                        ForEach(SitelenFont.allCases) { font in
                            Text(font.displayName).tag(font)
                        }
                    }
                } label: {
                    colorScheme == .dark ? Image("sitelen-pona.dark") : Image("sitelen-pona")
                }
                
                Menu {
                    Picker("Language", selection: $displayLanguage) {
                        ForEach(DisplayLanguage.allCases) { lang in
                            Text(lang.rawValue).tag(lang)
                        }
                    }
                } label: {
                    colorScheme == .dark ? Image("sitelen-nimi.dark") : Image("sitelen-nimi")
                }
            }
            .padding(.horizontal, 8)
        }
    }
}
