//
//  ChatViewController.swift
//  Gather
//
//  Created by Brian Powell on 4/16/21.
//  Copyright © 2021 Brian Powell. All rights reserved.
//

import UIKit
import InputBarAccessoryView
import MessageKit

class ChatViewController: MessagesViewController, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate, MessagesDataSource {
	
	var messages: [Message] = []
	var member: Member!
	var user2: Member!

    override func viewDidLoad() {
        super.viewDidLoad()
		title = Globals.people[Globals.lastIdSelected]
		messageInputBar.delegate = self
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		member = Member(name: Globals.name, color: .darkGray, email: Globals.email)
		user2 = Member(name: Globals.people[Globals.lastIdSelected], color: .lightGray, email: Globals.people[Globals.lastIdSelected + 1])
		Globals.messagesBeingShown = true
		loadMessages()
    }
	
	func getMessagesFromRequest(errors: String, output: String) {
		print(output)
		if output != "" && output.count > 1 && output[output.startIndex] == "S" {
			let outString = String(output[output.index(after: output.startIndex)...]).components(separatedBy: ",")
			messages = []
			for i in 0...(outString.count / 2 - 1) {
				if outString[i*2] == member.email {
					let newMessage = Message(
						member: member,
						text: outString[i*2+1],
						messageId: UUID().uuidString)
					messages.append(newMessage)
				} else {
					let newMessage = Message(
						member: user2,
						text: outString[i*2+1],
						messageId: UUID().uuidString)
					messages.append(newMessage)
				}
			}
			messagesCollectionView.reloadData()
			loadMessages()
		}
	}
	
	func loadMessages() {
		if Globals.messagesBeingShown {
			Globals.request("/getMessages", input: "email=\(Globals.email)&pass=\(Globals.pass)&user=\(Globals.people[Globals.lastIdSelected + 1])", action: getMessagesFromRequest(errors:output:))
		}
	}
	
	func sendMessage (errors: String, output: String) {
		// customize here if needed
	}
	
	// MARK: - InputBarAccessoryViewDelegate
	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		let newMessage = Message(
		  member: member,
		  text: text,
		  messageId: UUID().uuidString)
		  
		messages.append(newMessage)
		inputBar.inputTextView.text = ""
		messagesCollectionView.reloadData()
		messagesCollectionView.scrollToBottom(animated: true)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
		
		Globals.request("/sendMessage", input: "content=\(text)&sender=\(Globals.email)&pass=\(Globals.pass)&recipient=\(Globals.people[Globals.lastIdSelected + 1])&date=\(dateFormatter.string(from: Date()))", action: sendMessage(errors:output:))
	}
	
	// MARK: - MessagesDataSource
	func numberOfSections(
	  in messagesCollectionView: MessagesCollectionView) -> Int {
	  return messages.count
	}
	
	func currentSender() -> SenderType {
		return Sender(id: member.email, displayName: member.name)
	}
	
	func messageForItem(
	  at indexPath: IndexPath,
	  in messagesCollectionView: MessagesCollectionView) -> MessageType {
	  
	  return messages[indexPath.section]
	}
	
	func messageTopLabelHeight(
	  for message: MessageType,
	  at indexPath: IndexPath,
	  in messagesCollectionView: MessagesCollectionView) -> CGFloat {
	  
	  return 12
	}
	
	func messageTopLabelAttributedText(
	  for message: MessageType,
	  at indexPath: IndexPath) -> NSAttributedString? {
	  
	  return NSAttributedString(
		string: message.sender.displayName,
		attributes: [.font: UIFont.systemFont(ofSize: 12)])
	}
	
	// MARK: - MessagesDisplayDelegate
	func configureAvatarView(
	  _ avatarView: AvatarView,
	  for message: MessageType,
	  at indexPath: IndexPath,
	  in messagesCollectionView: MessagesCollectionView) {
	  
	  let message = messages[indexPath.section]
	  let color = message.member.color
	  avatarView.backgroundColor = color
	}
}

// MARK: - MessagesLayoutDelegate
extension ViewController: MessagesLayoutDelegate {
  func heightForLocation(message: MessageType,
	at indexPath: IndexPath,
	with maxWidth: CGFloat,
	in messagesCollectionView: MessagesCollectionView) -> CGFloat {
	
	return 0
  }
}
