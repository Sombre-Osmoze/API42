//
//  Attachment.swift
//  API42
//
//  Created by Marcus Florentin on 12/06/2019.
//

import Foundation

public struct Attachments: CodingAPI {

	public let id : ID

	public let name : String?

	public let pdf : AttachmentPDF?

	public let pageCount : Int?

	public let createdAt : Date?

	public let pdfProcessing : Bool?

	public let slug : Slug?

	public let url : URL

	public let thumbUrl : URL?

	public let baseId : ID

	public let language : Language?

	public let type : String

	public let attachmentId : ID
	
}
