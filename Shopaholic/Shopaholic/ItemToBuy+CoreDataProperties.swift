//
//  ItemToBuy+CoreDataProperties.swift
//  Shopaholic
//
//  Created by Zdzislaw Sroczynski 2023.
//
//

import Foundation
import CoreData


extension ItemToBuy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemToBuy> {
        return NSFetchRequest<ItemToBuy>(entityName: "ItemToBuy")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var done: Bool
    @NSManaged public var favourite: Bool
    @NSManaged public var name: String?

}

extension ItemToBuy : Identifiable {

}
