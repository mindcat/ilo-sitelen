//
//  WordCard.swift
//  ilo sitelen
//
//  Created by koteczek on 3/11/26.
//

import SwiftUI

struct WordCard: View {
    let word: WordData
    let displayLanguage: DisplayLanguage
    let sitelenFont: SitelenFont
    let confidence: Float?
    
    var body: some View {
        HStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 4)
                .fill(word.category.color)
                .frame(width: 6)
                .padding(.vertical, 4)
            
            VStack(alignment: .leading, spacing: 6) {
                lemmaView
                
                Text(word.definitions?["en"] ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.primary.opacity(0.8))
                
                if let iso = word.origin?["iso"], !iso.isEmpty {
                    HStack(spacing: 4) {
                        Text("Origin: \(iso)")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                        
                        if let originWord = word.origin?["word"], !originWord.isEmpty {
                            Text(originWord)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                HStack(spacing: 6) {
                    if let conf = confidence, conf >= 0 {
                        Text("\(Int(conf * 100))%")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color(UIColor.tertiarySystemFill))
                            .foregroundStyle(.secondary)
                            .clipShape(Capsule())
                    }
                    
                    Text(word.category.rawValue)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(word.category.color.opacity(0.2))
                        .foregroundStyle(word.category.color)
                        .clipShape(Capsule())
                }
                
                Text(word.lemma)
                    .font(.custom(sitelenFont.rawValue, size: 36))
                    .foregroundStyle(.secondary)
            }
            .padding(.leading, 4)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.4), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    @ViewBuilder
    var lemmaView: some View {
        switch displayLanguage {
        case .kanata:
            let k = word.script?["kanata"] ?? ""
            Text(k.isEmpty ? word.lemma : k)
                .font(.headline)
                .fontWeight(.bold)
        case .anku:
            let a = word.script?["anku"] ?? ""
            Text(a.isEmpty ? word.lemma : a)
                .font(.headline)
                .fontWeight(.bold)
        default:
            Text(word.lemma)
                .font(.headline)
                .fontWeight(.bold)
        }
    }
}
