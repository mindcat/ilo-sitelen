//
//  LukinTokiAnte.swift
//  ilo sitelen
//
//  Created by koteczek on 3/11/26.
//

import SwiftUI

struct LukinTokiAnte: View {
    @State private var isEnglishTop: Bool = true
    @State private var inputText: String = "jan pali pi ma ale, o kama wan a!"
    @FocusState private var isInputFocused: Bool
    @State private var showFullscreenOutput: Bool = false
    @State private var selectedWord: WordData? = nil
    
    // Dictionary Mode State
    @State private var isDictionaryMode: Bool = false
    @State private var sheetDetent: PresentationDetent = .fraction(0.45)
    
    @ObservedObject var dictManager: DictionaryManager
    @Binding var displayLanguage: DisplayLanguage
    @Binding var sitelenFont: SitelenFont
    @Binding var isDrawingMode: Bool
    @Binding var selection: Int
    
    @Environment(\.colorScheme) var colorScheme
    
    var topLanguage: String { isEnglishTop ? "English" : "toki pona" }
    var bottomLanguage: String { isEnglishTop ? "toki pona" : "English" }
    
    let targetColor = Color.cyan
    
    func getWordData(for token: String) -> WordData {
        let cleanToken = token.lowercased().trimmingCharacters(in: .punctuationCharacters)
        if let dictWord = dictManager.find(cleanToken) {
            return dictWord
        }
        
        let isProper = token.first?.isUppercase ?? false
        return WordData(
            lemma: cleanToken,
            sitelenpona: nil,
            origin: ["iso": isProper ? "Proper Noun" : "Unknown Word"],
            script: ["kanata": "ᕐ" + token, "anku": token],
            categories: ["semantic": [isProper ? "people" : "unknown"]],
            definitions: ["en": isProper ? "A proper noun, likely a name or place." : "This word is not recognized in the current dictionary."]
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 16) {
                        VStack(spacing: 0) {
                            
                            // MARK: - Top Box (Input)
                            VStack(alignment: .leading, spacing: 12) {
                                Button(action: {}) {
                                    HStack(spacing: 4) {
                                        Text(topLanguage)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                }
                                
                                HStack(alignment: .top) {
                                    TextField("Enter text", text: $inputText, axis: .vertical)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                        .tint(targetColor)
                                        .focused($isInputFocused)
                                    
                                    Spacer()
                                    Button(action: {
                                        // TODO: Dictation
                                    }) {
                                        Image(systemName: "mic")
                                            .font(.title2)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .frame(minHeight: 100, alignment: .top)
                            }
                            .padding()
                            
                            // MARK: - Swap Button & Divider
                            ZStack {
                                Divider()
                                    .frame(width: 325, height: 2)
                                    .overlay(Color.primary.opacity(0.1))
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        isEnglishTop.toggle()
                                        isDictionaryMode = false
                                        selectedWord = nil
                                    }
                                }) {
                                    Image(systemName: "arrow.trianglehead.swap")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(targetColor)
                                        .padding(10)
                                        .background(colorScheme == .dark ? Color(UIColor.systemGray5) : Color(UIColor.systemGray6))
                                        .clipShape(Circle())
                                        .rotation3DEffect(
                                            .degrees(isEnglishTop ? 180 : 0),
                                            axis: (x: 1.0, y: 0.0, z: 0.0)
                                        )
                                }
                            }
                            
                            // MARK: - Bottom Box (Output)
                            VStack(alignment: .leading, spacing: 12) {
                                Button(action: {}) {
                                    HStack(spacing: 4) {
                                        Text(bottomLanguage)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(targetColor)
                                    }
                                }
                                
                                HStack(alignment: .top) {
                                    if inputText.isEmpty {
                                        Text(isEnglishTop ? "toki pona..." : "Translated text...")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(targetColor.opacity(0.5))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    } else {
                                        if isEnglishTop {
                                            if isDictionaryMode {
                                                // FlowLayout Active
                                                FlowLayout(spacing: 2) {
                                                    let tokens = inputText.split(separator: " ").map(String.init)
                                                    ForEach(Array(tokens.enumerated()), id: \.offset) { index, token in
                                                        let wordData = getWordData(for: token)
                                                        let isSelected = selectedWord?.lemma == wordData.lemma
                                                        
                                                        Button(action: {
                                                            isInputFocused = false
                                                            sheetDetent = .fraction(0.25)
                                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                                                selectedWord = wordData
                                                            }
                                                        }) {
                                                            dictManager.tokiRenderer(token, lang: displayLanguage, font: sitelenFont)
                                                                .foregroundColor(isSelected ? .white : targetColor)
                                                                .padding(.leading, 3)
                                                                .padding(.vertical, 3)
                                                                .contentShape(Rectangle()) // Massive hit target
                                                                .background(isSelected ? targetColor : Color.clear)
                                                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                                        }
                                                        .buttonStyle(.plain)
                                                    }
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            } else {
                                                dictManager.tokiRenderer(inputText, lang: displayLanguage, font: sitelenFont)
                                                    .foregroundColor(targetColor)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                        } else {
                                            Text(inputText).font(.title).fontWeight(.bold)
                                                .foregroundColor(targetColor)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                    
                                    Button(action: {}) {
                                        Image(systemName: "speaker.wave.2")
                                            .font(.title2)
                                            .foregroundColor(targetColor)
                                    }
                                }
                                .frame(minHeight: 100, alignment: .top)
                                
                                // MARK: Bottom Actions
                                HStack(spacing: 24) {
                                    Button(action: {
                                        showFullscreenOutput = true
                                    }) { Image(systemName: "arrow.up.left.and.arrow.down.right") }
                                    
                                    Button(action: {
                                        // TODO: Star memory handling
                                    }) { Image(systemName: "star") }
                                    
                                    if isEnglishTop {
                                        Button(action: {
                                            isInputFocused = false
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                                isDictionaryMode.toggle()
                                                if !isDictionaryMode {
                                                    selectedWord = nil
                                                }
                                            }
                                        }) {
                                            Image(systemName: isDictionaryMode ? "character.book.closed.fill" : "character.book.closed")
                                        }
                                    }
                                    
                                    Button(action: {
                                        UIPasteboard.general.string = inputText
                                    }) { Image(systemName: "doc.on.doc") }
                                    
                                    Spacer()
                                }
                                .font(.title3)
                                .foregroundColor(targetColor.opacity(0.8))
                                .padding(.top, 8)
                            }
                            .padding()
                        }
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                        .padding(.top, 16)
                        
                        Spacer(minLength: 32)
                    }
                }
                .scrollDisabled(selectedWord != nil)
            }
            .navigationTitle(dictManager.localizedText("ilo toki ante", "Translator", lang: displayLanguage, font: sitelenFont))
            .toolbar {
                MainToolbar(
                    selection: $selection,
                    isDrawingMode: $isDrawingMode,
                    sitelenFont: $sitelenFont,
                    displayLanguage: $displayLanguage,
                    isInputFocused: isInputFocused,
                    onDismissFocus: { isInputFocused = false },
                    isWordSelected: isDictionaryMode,
                    onDismissWord: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            isDictionaryMode = false
                            selectedWord = nil
                        }
                    }
                )
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .sheet(isPresented: Binding(
                get: { isDictionaryMode && selectedWord != nil },
                set: { newValue in
                    if !newValue {
                        selectedWord = nil
                        sheetDetent = .fraction(0.25)
                    }
                }
            )) {
                WordDetailView(
                    word: selectedWord ?? getWordData(for: "toki"),
                    displayLanguage: displayLanguage,
                    sitelenFont: sitelenFont,
                    dictionaryMode: true
                )
                .presentationDetents([.fraction(0.25), .large], selection: $sheetDetent)
                .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.25)))
                .presentationBackground(.clear)
                .presentationDragIndicator(.hidden)
            }
            .fullScreenCover(isPresented: $showFullscreenOutput) {
                LandscapeTextView(
                    text: inputText.isEmpty ? (isEnglishTop ? "toki pona..." : "Translated text...") : inputText,
                    isTokiPona: isEnglishTop,
                    dictManager: dictManager,
                    displayLanguage: displayLanguage,
                    sitelenFont: sitelenFont
                )
            }
        }
    }
}

// MARK: - FlowLayout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? UIScreen.main.bounds.width, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            let point = result.points[index]
            subview.place(at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var points: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                points.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}
