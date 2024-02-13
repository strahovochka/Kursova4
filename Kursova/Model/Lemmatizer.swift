//
//  Lemmatizer.swift
//  Kursova
//
//  Created by Jane Strashok on 06.12.2023.
//

import Foundation
import UIKit
import CoreData

class Lemmatizer: Service, ServiceProtocol {
    var suffixes: [NSRegularExpression]
    var endings: NSRegularExpression
    
    override init() {
        suffixes = [
            try! NSRegularExpression(pattern: "(к|ц)$"),
            try! NSRegularExpression(pattern: "(г|з)$"),
            try! NSRegularExpression(pattern: "(х|с)$")
        ]
        
        endings = try! NSRegularExpression(pattern: "(я|а|и|і|у|ою|ею|о|е|ю)$")
        super.init()
    }

    func processWord(_ word: String) -> String {
        if checked(word) {
            var saveWord = endings.replace(word, with: "")
            let save = saveWord
            if suffixes[0].matches(saveWord) {
                saveWord = suffixes[0].replace(saveWord, with: "")
                let checkReg = try! NSRegularExpression(pattern: "(ра|ни|ки|щи|ів|ри)$")
                if checkReg.matches(saveWord) {
                    saveWord = save
                }
            } else if suffixes[1].matches(saveWord) {
                saveWord = suffixes[1].replace(saveWord, with: "")
                let checkReg = try! NSRegularExpression(pattern: "(^но|йо|юн|ту|ни|ля|дь|ле|ура|бра|пра|ова|два|бло|оло|^ва|рло|оро|ру|бо|на|ар|ря|ілу|слу|фу|омо|змо|емо|дмо|оль|ль|ари)$")
                if !checkReg.matches(saveWord) {
                    saveWord = save
                }
            } else if suffixes[2].matches(saveWord) {
                saveWord = suffixes[2].replace(saveWord, with: "")
                let checkReg = try! NSRegularExpression(pattern: "(ва|да|ю|ура|ома|уба|ля|бло|пи|у|рі|^та)$")
                if !checkReg.matches(saveWord) {
                    saveWord = save
                }
            }
            return saveWord
        }
        return "Not valid"
    }
}
