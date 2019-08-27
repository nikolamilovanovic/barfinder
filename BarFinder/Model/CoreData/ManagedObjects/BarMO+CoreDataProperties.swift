//
//  BarMO+CoreDataProperties.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/18/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//
//

import Foundation
import CoreData


extension BarMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BarMO> {
        return NSFetchRequest<BarMO>(entityName: "Bar")
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var descr: String?
    @NSManaged public var distance: Int64
    @NSManaged public var facebookUsername: String?
    @NSManaged public var formattedAddress: String?
    @NSManaged public var id: String?
    @NSManaged public var instagram: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var postalCode: String?
    @NSManaged public var state: String?
    @NSManaged public var twitter: String?
    @NSManaged public var url: String?
    @NSManaged public var bestPhoto: ImageHolderMO?

}
