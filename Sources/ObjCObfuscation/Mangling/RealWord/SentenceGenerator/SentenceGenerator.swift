//
// Created by Mengyu Li on 2020/12/29.
//

import Foundation

// https://www.talkenglish.com/vocabulary/english-vocabulary.aspx
protocol SentenceGenerator {
    func getUniqueSentence(length: Int) -> String?
}
