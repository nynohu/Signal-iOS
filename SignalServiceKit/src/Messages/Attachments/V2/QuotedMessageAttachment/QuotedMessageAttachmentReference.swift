//
// Copyright 2024 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

/// A reference to an attachment held by a quoted message reply.
public enum QuotedMessageAttachmentReference {
    /// The quoted message had a thumbnail-able attachment, so
    /// we created a thumbnail and reference it here.
    case thumbnail(Thumbnail)

    /// The quoted message had an attachment, but it couldn't be captured
    /// as a thumbnail (e.g. it was a generic file). We don't actually reference
    /// an attachment; instead we just keep some metadata from the original
    /// we use to render a stub at display time.
    case stub(Stub)

    public struct Thumbnail {
        /// Reference to the thumbnail created from the original.
        public let attachmentRef: TSResourceReference
        /// The mimeType of the _original_ attachment, not of the thumbnail.
        public let mimeType: String?
        /// The sourceFilename from the original attachment's sender.
        /// See Attachment.sourceFilename.
        public let sourceFilename: String?
    }

    public struct Stub {
        public let mimeType: String?
        public let sourceFilename: String?

        public init?(mimeType: String?, sourceFilename: String?) {
            // Need at least one, otherwise there's no point!
            guard mimeType != nil || sourceFilename != nil else {
                return nil
            }
            self.mimeType = mimeType
            self.sourceFilename = sourceFilename
        }

        public init?(_ info: OWSAttachmentInfo) {
            self.init(mimeType: info.contentType, sourceFilename: info.sourceFilename)
        }
    }
}
