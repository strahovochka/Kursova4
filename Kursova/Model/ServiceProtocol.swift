//
//  Service.swift
//  Kursova
//
//  Created by Jane Strashok on 06.12.2023.
//

import Foundation

protocol ServiceProtocol {
    func processWords() -> [String]
    func processWord(_ word: String) -> String
}

extension ServiceProtocol {
    func isStopWord(_ word: String) -> Bool {
        let filename = "stop_words"
        var myCounter: Int

        guard let file = Bundle.main.url(forResource: filename, withExtension: "txt") else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            let contents = try String(contentsOf: file, encoding: String.Encoding.utf8 )
            let lines = contents.split(separator:"\n")
            
            myCounter = lines.count
            for i in 0..<myCounter {
                if word == lines[i] {
                    return true
                }
            }

            } catch {

                return false

            }
        return false
    }
    
    func isOk(_ word: String) -> Bool {
        var vowels = try! NSRegularExpression(pattern: "(а|о|у|и|і|е|я|ї|ю|є)")
        var vowels2 = try! NSRegularExpression(pattern: "[^аоуиіеяїює]")
        if word.count > 3 {
            if (vowels.matches(word) && vowels2.matches(word)) {
                return true
            }
        }
        return false
    }
    
    func checked(_ word: String) -> Bool {
        isOk(word) && !isStopWord(word)
    }
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
    
    func replace(_ string: String, with: String) -> String {
        let range = NSRange(location: 0, length: string.utf16.count)
        return stringByReplacingMatches(in: string, range: range, withTemplate: with)
        
    }
}
