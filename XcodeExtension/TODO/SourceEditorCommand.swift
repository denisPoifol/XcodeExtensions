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
        for selectionObject in invocation.buffer.selections {
            guard let selection = selectionObject as? XCSourceTextRange else { continue }
            replace(selection, in: invocation.buffer, with: comment)
        }
        completionHandler(nil)
    }

    // MARK - private methods

    private func replace(_ selection: XCSourceTextRange, in buffer: XCSourceTextBuffer, with text: String) {
        if selection.start.line == selection.end.line {
            let line = selection.start.line
            guard var lineToChange = buffer.lines[line] as? String else { return }
            let subRangeStartIndex = lineToChange.index(lineToChange.startIndex, offsetBy: selection.start.column)
            guard selection.end.column > selection.start.column else {
                lineToChange.insert(contentsOf: text.characters, at: subRangeStartIndex)
                buffer.lines[selection.start.line] = lineToChange
                return
            }
            let subRangeEndIndex = lineToChange.index(lineToChange.startIndex, offsetBy: selection.end.column - 1)
            lineToChange.replaceSubrange(subRangeStartIndex...subRangeEndIndex, with: text)
            buffer.lines[selection.start.line] = lineToChange
        } else if selection.start.line + 1 == selection.end.line {
            guard
                let firstLine = buffer.lines[selection.start.line] as? String,
                let lastLine = buffer.lines[selection.end.line] as? String
                else { return }
            if selection.end.column == 0 {
                replace(
                    XCSourceTextRange(
                        start: selection.start,
                        end: XCSourceTextPosition(
                            line: selection.start.line,
                            column: firstLine.characters.count
                        )
                    ),
                    in: buffer, with: text)
            }
            let groupedLines = firstLine.appending(lastLine).replacingOccurrences(of: "\n", with: "")
            let newSelection = XCSourceTextRange(
                start: selection.start,
                end: XCSourceTextPosition(
                    line: selection.start.line,
                    column: groupedLines.characters.count + selection.end.column - lastLine.characters.count + 1
                )
            )
            buffer.lines.removeObject(at: selection.end.line)
            buffer.lines.replaceObject(at: selection.start.line, with: groupedLines)
            replace(newSelection, in: buffer, with: text)
        } else {
            let newSelection = XCSourceTextRange(
                start: selection.start,
                end: XCSourceTextPosition(
                    line: selection.start.line + 1,
                    column: selection.end.column
                )
            )
            let indexSet: IndexSet = IndexSet(integersIn: (selection.start.line + 1)...(selection.end.line - 1))
            buffer.lines.removeObjects(at: indexSet)
            replace(newSelection, in: buffer, with: text)
        }
    }

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
