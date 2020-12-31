//
// Created by Mengyu Li on 2020/12/30.
//

import Foundation
import Logging
import Senna

public let logger = Logger(label: "Logger") { (_: String) -> LogHandler in
    Handler(sink: Standard.out, formatter: Formatter.default, logLevel: .trace)
}
