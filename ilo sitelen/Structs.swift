//
//  Structs.swift
//  ilo sitelen
//
//  Created by koteczek on 3/11/26.
//

import SwiftUI
import TOML
import Combine

struct WordData: Codable, Identifiable {
    let lemma: String
    let sitelenpona: [String]?
    let origin: [String: String]?
    let script: [String: String]?
    let categories: [String: [String]]?
    let definitions: [String: String]?
    
    var id: String { lemma }
    
    enum CodingKeys: String, CodingKey {
        case lemma, sitelenpona, origin, script, categories, definitions
    }
    
    var category: Category {
        if let sem = categories?["semantic"]?.first, let cat = Category(rawValue: sem) {
            return cat
        }
        return .unknown
    }
    
    func matches(_ query: String) -> Bool {
        let q = query.lowercased()
        let defMatch = definitions?.values.contains { $0.lowercased().contains(q) } ?? false
        let isoMatch = origin?["iso"]?.lowercased().contains(q) ?? false
        let catMatch = categories?["semantic"]?.contains { $0.lowercased().contains(q) } ?? false
        return lemma.contains(q) || defMatch || isoMatch || catMatch
    }
}

class DictionaryManager: ObservableObject {
    @Published var words: [WordData] = []
    
    init() {
        loadWordsFromBundle()
    }
    
    func loadWordsFromBundle() {
        let decoder = TOMLDecoder()
        var loadedWords: [WordData] = []
        var allURLs: [URL] = []
        
        if let subUrls = Bundle.main.urls(forResourcesWithExtension: "toml", subdirectory: "words") {
            allURLs.append(contentsOf: subUrls)
        }
        if let rootUrls = Bundle.main.urls(forResourcesWithExtension: "toml", subdirectory: nil) {
            allURLs.append(contentsOf: rootUrls)
        }
        
        for url in allURLs {
            let name = url.lastPathComponent
            if name == "typst.toml" || name == "semantic.toml" || name == "usage.toml" { continue }
            
            do {
                let content = try String(contentsOf: url, encoding: .utf8)
                let word = try decoder.decode(WordData.self, from: content)
                loadedWords.append(word)
            } catch {
            }
        }
        
        var uniqueWords = [String: WordData]()
        for word in loadedWords {
            uniqueWords[word.lemma] = word
        }
        
        self.words = Array(uniqueWords.values).sorted { $0.lemma < $1.lemma }
    }
    
    func find(_ lemma: String) -> WordData? {
        return words.first { $0.lemma == lemma }
    }
    
    func tokiRenderer(_ text: String, lang: DisplayLanguage, font: SitelenFont, fontSize: CGFloat = 24) -> Text {
            let words = text.split(separator: " ")
            if words.isEmpty { return Text("") }
            
            return words.reduce(Text("")) { (result, substring) -> Text in
                let wordStr = String(substring)
                let cleanWord = wordStr.lowercased().trimmingCharacters(in: .punctuationCharacters)
                let dictWord = find(cleanWord)
                
                var output = wordStr
                var useSitelenFont = false
                
                if let dictWord = dictWord {
                    switch lang {
                    case .kanata:
                        let k = dictWord.script?["kanata"] ?? ""
                        output = k.isEmpty ? wordStr : k
                    case .anku:
                        let a = dictWord.script?["anku"] ?? ""
                        output = a.isEmpty ? wordStr : a
                    case .tok:
                        output = wordStr
                        useSitelenFont = true
                    case .lasina, .en:
                        output = wordStr
                    }
                }
                
                var textSegment = Text(output)
                
                if useSitelenFont {
                    textSegment = textSegment.font(.custom(font.rawValue, size: fontSize))
                } else if lang == .kanata || lang == .anku {
                    textSegment = textSegment.font(.system(size: fontSize * (20.0/24.0)))
                } else {
                    textSegment = textSegment.font(.system(size: fontSize))
                }
                
                return Text("\(result)\(textSegment) ")
            }
        }
    
    func localizedText(_ lasina: String, _ en: String, lang: DisplayLanguage, font: SitelenFont) -> Text {
        if lang == .en {
            return Text(en).font(.body)
        } else {
            var fontToUse = font
            if lang == .tok { fontToUse = .nasin }
            return tokiRenderer(lasina, lang: lang, font: fontToUse)
        }
    }
    
    func localizedString(_ lasina: String, _ en: String, lang: DisplayLanguage) -> String {
        return lang == .en ? en : lasina
    }
}

enum Category: String, CaseIterable, Codable {
    case people, body, necessities, critters, sight, state, activity
    case elements, things, ideas, locating, descriptions, counting
    case connection, evoke, unknown
    
    var color: Color {
        switch self {
        case .people, .body: return Color(red: 220/255, green: 138/255, blue: 120/255)
        case .necessities: return Color(red: 4/255, green: 165/255, blue: 229/255)
        case .critters: return Color(red: 64/255, green: 160/255, blue: 43/255)
        case .sight: return Color(red: 30/255, green: 102/255, blue: 245/255)
        case .state: return Color(red: 136/255, green: 57/255, blue: 239/255)
        case .activity: return Color(red: 254/255, green: 100/255, blue: 11/255)
        case .elements: return Color(red: 23/255, green: 146/255, blue: 153/255)
        case .things: return Color(red: 223/255, green: 142/255, blue: 29/255)
        case .ideas: return Color(red: 114/255, green: 135/255, blue: 253/255)
        case .locating: return Color(red: 230/255, green: 69/255, blue: 83/255)
        case .descriptions: return Color(red: 32/255, green: 159/255, blue: 181/255)
        case .counting: return Color(red: 234/255, green: 118/255, blue: 203/255)
        default: return .gray
        }
    }
}

enum DisplayLanguage: String, CaseIterable, Identifiable {
    case tok = "sitelen pona"
    case en = "English"
    case lasina = "sitelen Lasina"
    case anku = "시테렌 안구"
    case kanata = "ᓯᑌᓓᓐ ᕐᑲᓇᑕ"
    var id: Self { self }
}

enum SitelenFont: String, CaseIterable, Identifiable {
    case nasin = "nasin-nanpa"
    case linja = "linja-sike"
    case telo = "sitelentelo"
    case seli = "sitelenselikiwenasuki"
    case fairfax = "Fairfax Pona"
    case leko = "sitelenleko"
    case frt = "-Regular"
    case lasin = "sitelen_pona_pi_lasin_lukin"
    
    var id: Self { self }
    
    var displayName: String {
        switch self {
        case .nasin: return "nasin nanpa"
        case .linja: return "linja sike"
        case .telo: return "sitelen telo"
        case .seli: return "sitelen seli kiwen"
        case .fairfax: return "fairfax pona"
        case .leko: return "sitelen leko"
        case .frt: return "してれん"
        case .lasin: return "sitelen lasin lukin"
        }
    }
}
