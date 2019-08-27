//
//  ImageHolderMO+CoreDataProperties.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/18/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit.UIImage

extension ImageHolderMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageHolderMO> {
        return NSFetchRequest<ImageHolderMO>(entityName: "ImageHolder")
    }

    @NSManaged public var image: UIImage?

}
