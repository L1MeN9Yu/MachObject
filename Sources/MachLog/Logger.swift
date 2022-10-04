//
// Created by Mengyu Li on 2020/12/30.
//

import Foundation
import Logging
import Senna

public let logger = Logger(label: "Logger") {
    Handler(name: $0, sink: StandardSink.out(), formation: Formation.standard, logLevel: .trace)
}
