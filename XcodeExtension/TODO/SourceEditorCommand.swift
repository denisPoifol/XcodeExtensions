//
//  SourceEditorCommand.swift
//  TODO
//
//  Created by Denis Poifol on 21/08/2017.
//  Copyright © 2017 Denis Poifol. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        let comment = todoString()
        guard
            let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange,
            var lastSelectionLine = invocation.buffer.lines[selection.end.line] as? String else {
                completionHandler(nil)
                return
        }
        let endOfSelectionIndex = lastSelectionLine.index(lastSelectionLine.startIndex, offsetBy: selection.end.column)
        lastSelectionLine.insert(contentsOf: comment.characters, at: endOfSelectionIndex)
        invocation.buffer.lines[selection.end.line] = lastSelectionLine
        completionHandler(nil)
    }

    // MARK: - private methods

    private func todoString() -> String {
        let date = Date()
        let dateString = DateFormatter.short.string(from: date)
        let userName = NSFullUserName()

        var comment = "// TODO (\(userName)) \(dateString) "
        comment.append("<#")
        comment.append("TODO")
        comment.append("#>")
        return comment
    }
}
