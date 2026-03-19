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
    
    var isInputFocused: Bool = false
    var onDismissFocus: () -> Void = {}
    
    var isWordSelected: Bool = false
    var onDismissWord: () -> Void = {}

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            if selection == 0 {
                Button(action: {
                    if isInputFocused {
                        onDismissFocus()
                    } else if isWordSelected {
                        onDismissWord()
                    } else {
                        // TODO: Camera action
                    }
                }) {
                    Image(systemName: (isInputFocused || isWordSelected) ? "checkmark" : "camera")
                        .font(.system(size: 15, weight: (isInputFocused || isWordSelected) ? .bold : .semibold))
                        .foregroundColor((isInputFocused || isWordSelected) ? .accentColor : .primary)
                }
            } else if selection == 1 {
                Button(action: {
                    if isWordSelected {
                        onDismissWord()
                    } else {
                        withAnimation { isDrawingMode.toggle() }
                    }
                }) {
                    Image(systemName: isWordSelected ? "checkmark" : "scribble.variable")
                        .font(.system(size: 15, weight: isWordSelected ? .bold : .semibold))
                        .foregroundColor(isWordSelected ? .accentColor : (isDrawingMode ? .accentColor : .primary))
                }
            }
        }
        
        ToolbarItem(placement: .topBarLeading) {
            HStack(spacing: 8) {
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
                    Image(systemName: "globe.desk")
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
        }
    }
}
