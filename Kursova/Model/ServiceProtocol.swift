//
//  Service.swift
//  Kursova
//
//  Created by Jane Strashok on 06.12.2023.
//

import Foundation
import UIKit
import CoreData

protocol ServiceProtocol {
    func processWord(_ word: String) -> String
}

class Service {
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func isWordSaved(_ word: String) -> (Bool, Word?) {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "content == %@", word)
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                return (false, nil)
            } else {
                let savedWord: [Word]
                do {
                    savedWord = try context.fetch(fetchRequest)
                    return (true, savedWord[0])
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                    return (false, nil)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return (false, nil)
        }
    }
    
    func processWords(_ words: [String]) -> (lemmatized: [String], stemed: [String]) {
        var lemmatizedWords = [String]()
        var stemmedWords = [String]()
        words.forEach {
            let savedData = isWordSaved($0)
            if savedData.0 {
                lemmatizedWords.append(savedData.1?.lem ?? "")
                stemmedWords.append(savedData.1?.stem ?? "")
            } else {
                let stemmedWord = Stemmer().processWord($0)
                let lemmatizedWord = Lemmatizer().processWord($0)
                lemmatizedWords.append(lemmatizedWord)
                stemmedWords.append(stemmedWord)
                if stemmedWord != "Not valid" && lemmatizedWord != "Not valid" {
                    let saveWord = Word(entity: Word.entity(), insertInto: context)
                    saveWord.content = $0
                    saveWord.lem = lemmatizedWord
                    saveWord.stem = stemmedWord
                    appDelegate.saveContext()
                }
            }
        }
        return (lemmatizedWords, stemmedWords)
    }
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
