//
//  FileAttachments.swift
//  API42
//
//  Created by Marcus Florentin on 12/06/2019.
//

import Foundation


public struct Thumb: CodingAPI {

	public let url : URL

}

public struct AttachmentPDF: CodingAPI {

	public struct PDF: CodingAPI {
		public let url : URL
	}

	public let pdf : PDF

	public let thumb : Thumb?

}
