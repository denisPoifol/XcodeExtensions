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
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
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
