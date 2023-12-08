//
//  Words.swift
//  Kursova
//
//  Created by Jane Strashok on 06.12.2023.
//

import Foundation
import NaturalLanguage

struct Words {
    var words = [String]()
    
    init(text: String) {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.setLanguage(.ukrainian)
        tokenizer.string = text
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            print(text[range])
            words.append(String(text[range]))
            return true
        }
    }
}
