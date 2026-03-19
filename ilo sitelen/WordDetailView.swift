//
//  WordDetailView.swift
//  ilo sitelen
//
//  Created by koteczek on 3/12/26.
//

import SwiftUI

struct WordDetailView: View {
    let word: WordData
    let displayLanguage: DisplayLanguage
    let sitelenFont: SitelenFont
    let dictionaryMode: Bool
    
    @AppStorage("showFontNasin") private var showFontNasin = true
    @AppStorage("showFontLinja") private var showFontLinja = true
    @AppStorage("showFontTelo") private var showFontTelo = true
    @AppStorage("showFontSeli") private var showFontSeli = true
    @AppStorage("showFontFairfax") private var showFontFairfax = true
    @AppStorage("showFontLeko") private var showFontLeko = true
    @AppStorage("showFontFrt") private var showFontFrt = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                
//                if dictionaryMode {
//                    Color.clear
//                        .frame(height: UIScreen.main.bounds.height * 0.45)
//                        .allowsHitTesting(false)
//                }
                
                WordCard(word: word, displayLanguage: displayLanguage, sitelenFont: sitelenFont, confidence: nil)
                    .allowsHitTesting(false)
                
                VStack(spacing: 24) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            if (displayLanguage != .lasina) && (displayLanguage != .tok) && (displayLanguage != .en) {
                                Text("Lasina: \(word.lemma)")
                                    .font(.subheadline).foregroundStyle(.secondary)
                            }
                            if displayLanguage != .kanata {
                                let k = word.script?["kanata"] ?? word.lemma
                                Text("Kanata: \(k)")
                                    .font(.subheadline).foregroundStyle(.secondary)
                            }
                            if displayLanguage != .anku {
                                let a = word.script?["anku"] ?? word.lemma
                                Text("Anku: \(a)")
                                    .font(.subheadline).foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Button(action: {}) {
                                Image(systemName: "speaker.wave.2.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(word.category.color)
                            }
                            
                            Link(destination: URL(string: "https://sona.pona.la/wiki/\(word.lemma)")!) {
                                ZStack {
                                    Circle()
                                        .fill(word.category.color)
                                        .frame(width: 32, height: 32)
                                    Text("W")
                                        .font(.system(size: 16, weight: .bold, design: .serif))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            if showFontNasin { FontPreviewBubble(word: word.lemma, font: .nasin) }
                            if showFontLinja { FontPreviewBubble(word: word.lemma, font: .linja) }
                            if showFontTelo { FontPreviewBubble(word: word.lemma, font: .telo) }
                            if showFontSeli { FontPreviewBubble(word: word.lemma, font: .seli) }
                            if showFontFairfax { FontPreviewBubble(word: word.lemma, font: .fairfax) }
                            if showFontLeko { FontPreviewBubble(word: word.lemma, font: .leko) }
                            if showFontFrt { FontPreviewBubble(word: word.lemma, font: .frt) }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Replaced solid grey colors with transparent primary for layering
                    VStack(alignment: .leading, spacing: 12) {
                        Text("lipamanka semantic space")
                            .font(.headline)
                            .foregroundStyle(word.category.color)
                        
                        Text("This is a placeholder for the lipamanka semantic space. It will likely be at least a paragraph long, detailing the intricate nuances, common usage contexts, and specific boundaries of this word's meaning in relation to others within the toki pona vocabulary.")
                            .font(.body)
                            .foregroundStyle(.primary.opacity(0.8))
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.primary.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ku translations")
                                .font(.caption).bold().foregroundStyle(.secondary)
                            Text("placeholder, translation, words, go, here")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.primary.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        VStack(alignment: .center, spacing: 8) {
                            Text("ku recognizability")
                                .font(.caption).bold().foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                            Text("84%")
                                .font(.title2).bold()
                                .foregroundStyle(word.category.color)
                        }
                        .padding()
                        .background(Color.primary.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("luka pona")
                            .font(.headline)
                            .foregroundStyle(word.category.color)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.primary.opacity(0.05))
                            .frame(height: 200)
                            .overlay(
                                Image(systemName: "hand.wave")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.secondary)
                            )
                        
                        Text("Placeholder description for the luka pona sign. This explains the physical movement required to produce the sign accurately.")
                            .font(.subheadline)
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding()
                    .background(Color.primary.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                }
                .padding(.vertical, 24)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.white.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
            }
            .padding(20)
        }
    }
}

struct FontPreviewBubble: View {
    let word: String
    let font: SitelenFont
    
    var body: some View {
        VStack(spacing: 8) {
            Text(word)
                .font(.custom(font.rawValue, size: 32))
                .frame(width: 64, height: 64)
                .background(Color.primary.opacity(0.05))
                .clipShape(Circle())
            
            Text(font.displayName)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}
