//
//  LukinLipuNimi.swift
//  ilo sitelen
//
//  Created by koteczek on 3/11/26.
//

import SwiftUI
import PencilKit
import Combine
import Vision

struct LukinLipuNimi: View {
    @ObservedObject var dictManager: DictionaryManager
    @ObservedObject var drawingProcessor: DrawingProcessor
    @Binding var displayLanguage: DisplayLanguage
    @Binding var sitelenFont: SitelenFont
    @Binding var isDrawingMode: Bool
    @Binding var showModelInput: Bool
    @Binding var selection: Int
    
    @State private var searchText: String = ""
    @State private var pkCanvas = PKCanvasView()
    
    var searchResults: [WordData] {
        var results = dictManager.words
        
        if !searchText.isEmpty {
            results = results.filter { $0.matches(searchText) }
        }
        
        if isDrawingMode, !drawingProcessor.predictions.isEmpty {
            var confidenceMap: [String: Float] = [:]
            for pred in drawingProcessor.predictions {
                confidenceMap[pred.identifier] = pred.confidence
            }
            
            results.sort { w1, w2 in
                if w1.lemma == "meso" && w2.lemma != "meso" { return false }
                if w2.lemma == "meso" && w1.lemma != "meso" { return true }
                
                let conf1 = confidenceMap[w1.lemma] ?? -1.0
                let conf2 = confidenceMap[w2.lemma] ?? -1.0
                
                if conf1 != conf2 {
                    return conf1 > conf2
                }
                
                return w1.lemma < w2.lemma
            }
        }
        
        return results
    }
    
    func getConfidence(for lemma: String) -> Float? {
        guard isDrawingMode, !drawingProcessor.predictions.isEmpty else { return nil }
        if let match = drawingProcessor.predictions.first(where: { $0.identifier == lemma }) {
            return match.confidence
        }
        return -1.0
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    if isDrawingMode {
                        VStack {
                            HStack {
                                Text("Draw a sitelen pona glyph")
                                    .font(.caption).foregroundStyle(.secondary)
                                Spacer()
                                Button(action: {
                                    pkCanvas.drawing = PKDrawing()
                                    drawingProcessor.debugImage = nil
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.horizontal)
                            
                            DrawingPad(canvasView: $pkCanvas, onDrawingChanged: {
                                drawingProcessor.drawingSubject.send(pkCanvas.drawing)
                            })
                            .frame(height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                            
                            if showModelInput {
                                if let debugImg = drawingProcessor.debugImage {
                                    VStack(spacing: 4) {
                                        Text("Model Input (28x28 Grid)")
                                            .font(.caption2).foregroundStyle(.tertiary)
                                        
                                        Image(uiImage: debugImg)
                                            .interpolation(.none)
                                            .resizable()
                                            .frame(width: 84, height: 84)
                                            .border(Color.gray.opacity(0.3), width: 1)
                                    }
                                    .padding(.top, 8)
                                }
                            }
                            
                            Divider().padding(.vertical, 8)
                        }
                        .padding(.top)
                    }

                    LazyVStack(spacing: 12) {
                        ForEach(searchResults) { word in
                            WordCard(
                                word: word,
                                displayLanguage: displayLanguage,
                                sitelenFont: sitelenFont,
                                confidence: getConfidence(for: word.lemma)
                            )
                        }
                    }
                    .padding()
                }
            }
            .searchable(text: $searchText, prompt: dictManager.localizedString("alasa nimi...", "Search words...", lang: displayLanguage))
            .navigationTitle(dictManager.localizedText("lipu nimi", "Dictionary", lang: displayLanguage, font: sitelenFont))
            .toolbar {
                MainToolbar(selection: $selection, isDrawingMode: $isDrawingMode, sitelenFont: $sitelenFont, displayLanguage: $displayLanguage)
            }
        }
    }
}
