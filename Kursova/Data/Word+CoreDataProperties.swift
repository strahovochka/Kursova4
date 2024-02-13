//
//  Word+CoreDataProperties.swift
//  Kursova
//
//  Created by Jane Strashok on 10.02.2024.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var content: String?
    @NSManaged public var stem: String?
    @NSManaged public var lem: String?

}

extension Word : Identifiable {

}
