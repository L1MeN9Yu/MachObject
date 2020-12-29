//
// Created by Mengyu Li on 2020/12/29.
//

import Foundation

public extension String {
    var capitalizedOnFirstLetter: String {
        prefix(1).capitalized + dropFirst()
    }
}
