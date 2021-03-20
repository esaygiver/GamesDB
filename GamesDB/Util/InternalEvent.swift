//
//  InternalEvent.swift
//  GamesDB
//
//  Created by admin on 19.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

enum InternalEvent: String {

    case gameFavorited
    
    
    var attachmentName: String {
        switch self {
        case .gameFavorited:
            return "GameFavorited"
        }
    }

    func send(attachment: AnyObject?) {
        var userInfo = Dictionary<String, AnyObject>()
        if let unwrappedAttachment = attachment {
            userInfo[attachmentName] = unwrappedAttachment
        }
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: rawValue),
            object: nil,
            userInfo: userInfo
        )
    }

    static func addObservers(observers: [(event: InternalEvent, selector: Selector)], controller: AnyObject) {
        for observer in observers {
            NotificationCenter.default.addObserver(
                controller,
                selector: observer.selector,
                name: NSNotification.Name(rawValue: observer.event.rawValue),
                object: nil
            )
        }
    }

    static func removeObservers(observers: [(event: InternalEvent, selector: Selector)], controller: AnyObject) {
        for observer in observers {
            NotificationCenter.default.removeObserver(
                controller,
                name: NSNotification.Name(rawValue: observer.event.rawValue),
                object: nil
            )
        }
    }

}
