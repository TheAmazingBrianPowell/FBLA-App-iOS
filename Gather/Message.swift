//
//  Message.swift
//  Gather
//
//  Created by Brian Powell on 4/16/21.
//  Copyright © 2021 Brian Powell. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct Member {
	let name: String
	let color: UIColor
	let email: String
}

struct Message {
	let member: Member
	let text: String
	let messageId: String
}

extension Message: MessageType {
	var sender: SenderType {
		return Sender(id: member.email, displayName: member.name)
	}
  
	var sentDate: Date {
		return Date()
	}
  
	var kind: MessageKind {
		return .text(text)
	}
}
