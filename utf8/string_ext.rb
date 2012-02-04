class String
  # Send any string to the clipboard, the easy way.
  #
  # http://borkware.com/quickies/single?id=363
  # Objective-C Implemenation:
  #  @implementation NSString (PasteboardGoodies)
  #  
  #  - (void) sendToPasteboard
  #  {
  #          [[NSPasteboard generalPasteboard] 
  #              declareTypes: [NSArray arrayWithObject: NSStringPboardType]
  #              owner:nil];
  #          [[NSPasteboard generalPasteboard]
  #              setString: self
  #              forType: NSStringPboardType];
  #  } // sendToPasteboard
  #  
  #  @end // PasteboardGoodies
  
  def sendToPasteboard
    NSPasteboard.generalPasteboard.declareTypes([NSStringPboardType], owner: nil)
    NSPasteboard.generalPasteboard.setString(self, forType: NSStringPboardType)
  end
end