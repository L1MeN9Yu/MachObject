//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation
import MachOParser

/// Architecture-erased protocol for 32/64 ObjC images
protocol ObjcImage {
    func getObjectsFromList<Element>(section list: Section?, creator: (Int) -> Element) -> [Element]
    func create(offset: Int) -> ObjcClass
    func create(offset: Int) -> ObjcCategory
    func create(offset: Int) -> ObjcProtocol
}
