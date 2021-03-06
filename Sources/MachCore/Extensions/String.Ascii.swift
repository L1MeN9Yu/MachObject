//
// Created by Mengyu Li on 2020/8/4.
//

import Foundation

public extension String {
    var isASCII: Bool {
        unicodeScalars.allSatisfy { (element: UnicodeScalarView.Element) -> Bool in element.isASCII }
    }
}
