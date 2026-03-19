//
//  TranslateView.swift
//  ilo sitelen
//
//  Created by koteczek on 3/11/26.
//
import SwiftUI

struct TranslateView: View {
    @State private var isEnglishTop: Bool = true
    @State private var inputText: String = ""
    @State private var isSitelenPona: Bool = false
    @FocusState private var isInputFocused: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var topLanguage: String { isEnglishTop ? "English (US)" : "toki pona" }
    var bottomLanguage: String { isEnglishTop ? "toki pona" : "English (US)" }
    
    let targetColor = Color.cyan
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                // list menu placeholder
                Button(action: {  }) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(UIColor.systemGray6))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text(isEnglishTop ? "Translate" : "ilo toki ante")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: { /* placeholder */ }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                            .background(Color(UIColor.systemGray6))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        isInputFocused = false
                    }) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(targetColor)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Text(topLanguage)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.caption2)
                                .foregroundColor(.secondary)
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
                        
                        if isEnglishTop {
                            Button(action: {}) {
                                Image(systemName: "mic")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }
                        } else {
                            HStack(spacing: 16) {
                                Button(action: {}) {
                                    Image(systemName: "camera")
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                }
                                
                                Button(action: {
                                    withAnimation { isSitelenPona.toggle() }
                                }) {
                                    if isSitelenPona {
                                        colorScheme == .dark ? Image("sitelen-pona.dark") : Image("sitelen-pona")
                                    } else {
                                        Image(systemName: "character.cursor.ibeam")
                                            .font(.title2)
                                    }
                                }
                                .foregroundColor(.primary)
                            }
                        }
                    }
                    .frame(minHeight: 100, alignment: .top)
                }
                .padding()
                
                ZStack {
                    Divider()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            isEnglishTop.toggle()
                        }
                    }) {
                        Image(systemName: "arrow.trianglehead.swap")
                            .rotationEffect(.degrees(90)) // Rotated to point up and down
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(targetColor)
                            .padding(10)
                            .background(Color(UIColor.systemGray6))
                            .clipShape(Circle())
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Text(bottomLanguage)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(targetColor)
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.caption2)
                                .foregroundColor(targetColor.opacity(0.7))
                        }
                    }
                    
                    HStack(alignment: .top) {
                        Text(isEnglishTop ? "toki pona..." : "Translated text...")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(targetColor.opacity(0.5))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if !isEnglishTop {
                            Button(action: {}) {
                                Image(systemName: "mic")
                                    .font(.title2)
                                    .foregroundColor(targetColor)
                            }
                        } else {
                            Button(action: {
                                withAnimation { isSitelenPona.toggle() }
                            }) {
                                if isSitelenPona {
                                    colorScheme == .dark ? Image("sitelen-pona.dark") : Image("sitelen-pona")
                                } else {
                                    Image(systemName: "character.cursor.ibeam")
                                        .font(.title2)
                                }
                            }
                            .foregroundColor(targetColor)
                        }
                    }
                    .frame(minHeight: 100, alignment: .top)
                    
                    HStack(spacing: 24) {
                        Button(action: {}) { Image(systemName: "arrow.up.left.and.arrow.down.right") }
                        Button(action: {}) { Image(systemName: "star") }
                        Button(action: {}) { Image(systemName: "doc.on.doc") }
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
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}
