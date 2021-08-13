//
// Created by Mengyu Li on 2020/12/30.
//

import Foundation
import Logging
import Senna

public let logger = Logger(label: "Logger") {
    Handler(name: $0, sink: Standard.out, formatter: Formatter.standard, logLevel: .trace)
}
