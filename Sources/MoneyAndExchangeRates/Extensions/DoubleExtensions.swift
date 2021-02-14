//  Created by Michael Rutherford on 2/14/21.
//  copied from https://stackoverflow.com/questions/41744278/count-number-of-decimal-places-in-a-float-or-decimal-in-swift

import Foundation

extension Double {
    /// Number of decimal places  (e.g. 1.2345 would return 4)
    func decimalCount() -> Int {
        if self == Double(Int(self)) {
            return 0
        }

        let integerString = String(Int(self))
        let doubleString = String(Double(self))
        let decimalCount = doubleString.count - integerString.count - 1

        return decimalCount
    }
}
