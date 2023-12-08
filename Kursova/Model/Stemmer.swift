//
//  Stemmer.swift
//  Kursova
//
//  Created by Jane Strashok on 06.12.2023.
//

import Foundation

class Stemmer: ServiceProtocol {
    private let words: [String]
    
    var langParts: [NSRegularExpression]
    var prefixes: NSRegularExpression
    
    init(words: [String]) {
        self.words = words
        langParts = [
            try! NSRegularExpression(pattern: "(сь|ся|си)$"),
            try! NSRegularExpression(pattern: "(ив|ать|уть|ять|ють|у|ю|ав|али,|ши|е|ме|ати|ути|яти|юти|є|иш|ить|ила|ило|ите|или|иму|имеш|име|имуть|имете|имем)$"),
            try! NSRegularExpression(pattern: "(ими|ій|ий|а|е|ова|ове|ів|є|їй|єє|еє|я|ім|ем|им|ім|их|іх|ою|йми|іми|у|ю|ого|ому|ї|і)$"),
            try! NSRegularExpression(pattern: "(учи|ючи|ачи|ячи|вши)$"),
            try! NSRegularExpression(pattern: "(а|ев|ов|е|ями|ами|еи|и|ей|ой|ий|й|иям|ям|ием|ем|ам|ом|о|у|ах|иях|ь|ию|ью|ю|и|ья|я|і|ові|ї|ею|єю|ою|є|еві|ем|єм|ів|їв|ю)$")
        ]
        
        prefixes = try! NSRegularExpression(pattern: "^(без|роз|через|перед|понад|при|пре|прі|архі)")
    }
    
    func processWords() -> [String] {
        words.map { processWord($0) }
    }
    
    func processWord(_ word: String) -> String {
        if checked(word) {
            var saveWord = word
            saveWord = prefixes.replace(saveWord, with: "")
            if langParts[0].matches(saveWord) {
                saveWord = langParts[0].replace(saveWord, with: "")
                if langParts[1].matches(saveWord) {
                    saveWord = langParts[1].replace(saveWord, with: "")
                } else if langParts[2].matches(saveWord) {
                    saveWord = langParts[2].replace(saveWord, with: "")
                } else if langParts[3].matches(saveWord) {
                    saveWord = langParts[3].replace(saveWord, with: "")
                }
            } else {
                saveWord = langParts[4].replace(saveWord, with: "")
            }
            return saveWord
        }
        return "Not valid"
    }
    
    
}
