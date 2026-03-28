//
//  WordDetailView.swift
//  ilo sitelen
//
//  Created by koteczek on 3/12/26.
//

import SwiftUI
import AVFoundation

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
    @AppStorage("showLukaPona") private var showLukaPona = true
    @State private var audioPlayer: AVAudioPlayer?
    
    
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
                            
                            Spacer()
                            
                            HStack(spacing: 6) {
                                if let usage = word.usage {
                                    Text("\(usage)")
                                }
                                
                                if let iso = word.origin?["iso"] {
                                    if word.usage != nil {
                                        Text("•").foregroundStyle(.secondary.opacity(0.5))
                                    }
                                    Text(iso.uppercased())
                                }
                            }
                            .font(.caption2).bold()
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.primary.opacity(0.05))
                            .foregroundStyle(.secondary)
                            .clipShape(Capsule())
                            
                            Spacer()
                            
                            if let audioFile = word.audio {
                                Button {
                                    playAudio(filename: audioFile)
                                } label: {
                                    Image(systemName: "speaker.wave.2.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundStyle(word.category.color)
                                        .padding(.top, 4)
                                }
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
                    
                    if let semanticSpace = word.semantic {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("lipamanka semantic space")
                                    .font(.headline)
                                    .foregroundStyle(word.category.color)
                                Link(destination: URL(string: "https://lipamanka.gay/essays/dictionary#\(word.lemma)")!) {
                                    Image(systemName: "arrow.up.forward.app")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            
                            Text(semanticSpace)
                                .font(.body)
                                .foregroundStyle(.primary.opacity(0.8))
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(Color.primary.opacity(0.05))
//                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    
                    if let ku = word.ku, !ku.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ku usage")
                                .font(.headline)
                                .foregroundStyle(word.category.color)
                                    .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(ku, id: \.self) { ku_item in
                                        HStack(spacing: 4) {
                                            Text(ku_item.translation)
                                                .font(.subheadline)
                                            Text("\(ku_item.percentage)%")
                                                .font(.system(size: 10, weight: .bold))
                                                .padding(8)
                                                .background(word.category.color.opacity(0.2))
                                                .clipShape(Capsule())
                                        }
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 10)
                                        .background(Color.primary.opacity(0.05))
                                        .clipShape(Capsule())
                                    }
                                }
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.horizontal) # I WILL DEAL W THIS UI ANNOYANCE LATER
//                        .background(Color.primary.opacity(0.05))
//                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    if let comm = word.commentary, !comm.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("lipamanka semantic space")
                                    .font(.headline)
                                    .foregroundStyle(word.category.color)
                                Link(destination: URL(string: "https://linku.la/words/\(word.lemma)")!) {
                                    Image(systemName: "arrow.up.forward.app")
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                }
                                Spacer()
                            }
                            
                            Text(comm)
                                .font(.body)
                                .foregroundStyle(.primary.opacity(0.8))
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if showLukaPona, let signs = word.lukaPonaSigns, !signs.isEmpty {
                        LukaPonaSignCard(signs: signs, categoryColor: word.category.color).padding()
                    }
                    
                    
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

    private func playAudio(filename: String) {
        let name = (filename as NSString).deletingPathExtension
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}

struct LukaPonaSignCard: View {
    let signs: [LukaPonaSign]
    let categoryColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("luka pona")
                .font(.headline)
                .foregroundStyle(categoryColor)
            
            if let firstMp4 = signs.compactMap({ $0.mp4 }).first {
                LoopingVideoPlayer(filename: firstMp4)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            VStack(alignment: .leading, spacing: 16) {
                
                ForEach(signs) { sign in
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("gloss: \(sign.id)")
                            .font(.headline)
                            .foregroundStyle(categoryColor)
                        
                        if let params = sign.parameters {
                                HStack(spacing: 8) {
                                    
                                    HStack(spacing: -2) {
                                        Image(systemName: "hand.wave.fill")
                                        if sign.twohands {
                                            Image(systemName: "hand.wave.fill")
                                        }
                                    }
                                    .foregroundStyle(.secondary)
                                    
                                    HStack(spacing: 2) {
                                        Image(systemName: "hand.point.up")
                                        Text(params.handshape)
                                    }
                                    
                                    if let orientation = params.orientation {
                                        HStack(spacing: 2) {
                                            Image(systemName: "rotate.3d")
                                            Text(orientation)
                                        }
                                    }
                                    
                                    if let placement = params.placement {
                                        HStack(spacing: 2) {
                                            Image(systemName: "viewfinder")
                                            Text(placement)
                                        }
                                    }
                                    
                                    if let movement = params.movement {
                                        HStack(spacing: 2) {
                                            Image(systemName: "move.3d")
                                            Text(movement)
                                        }
                                    }
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                        
                        if let icons = sign.icons, !icons.isEmpty {
                            Text(icons)
                                .font(.subheadline)
                                .foregroundStyle(.primary.opacity(0.8))
                        }
                        
                        if let etymologies = sign.etymology, !etymologies.isEmpty {
                            Text(buildEtymologyString(from: etymologies))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if sign.id != signs.last?.id {
                        Divider()
                            .padding(.vertical, 4)
                    }
                }
            }
        }
        .padding()
        .background(Color.primary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func buildEtymologyString(from etymologies: [LukaPonaEtymology]) -> String {
        let mapped = etymologies.compactMap { "\($0.sign ?? "Unknown") (\($0.language))" }
        return "Etymology: " + mapped.joined(separator: ", ")
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
