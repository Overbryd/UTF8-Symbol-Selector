class MyNSTextFieldCell < NSTextFieldCell
  # This subclass shall enable a verticaly centered NSTextFieldCell
  # see also: http://stackoverflow.com/questions/1235219/is-there-a-right-way-to-have-nstextfieldcell-draw-vertically-centered-text
  #
  # Objective-C Implemenation:
  #
  #  - (NSRect)titleRectForBounds:(NSRect)theRect {
  #      NSRect titleFrame = [super titleRectForBounds:theRect];
  #      NSSize titleSize = [[self attributedStringValue] size];
  #      titleFrame.origin.y = theRect.origin.y + (theRect.size.height - titleSize.height) / 2.0;
  #      return titleFrame;
  #  }
  #  
  #  - (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
  #      NSRect titleRect = [self titleRectForBounds:cellFrame];
  #      [[self attributedStringValue] drawInRect:titleRect];
  #  }
  #
  def titleRectForBounds(rect)
    frame = super(rect)
    frame.origin.y = rect.origin.y + (rect.size.height - attributedStringValue.size.height) / 2.0
    frame
  end
  
  def drawInteriorWithFrame(cellFrame, inView:controlView)
    titleRect = titleRectForBounds(cellFrame)
    attributedStringValue.drawInRect(titleRect)
  end
end
