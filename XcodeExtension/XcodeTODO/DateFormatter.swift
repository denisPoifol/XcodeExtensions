//
//  DateFormatter.swift
//  XcodeExtension
//
//  Created by Denis Poifol on 21/08/2017.
//  Copyright © 2017 Denis Poifol. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let short: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    } ()
}
