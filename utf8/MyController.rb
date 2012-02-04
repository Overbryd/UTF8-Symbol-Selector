# MyController, no good name yet
# It acts as the main controller and data source for the table view
#
class MyController
  attr_accessor :searchField
  attr_accessor :tableView

  attr_accessor :filteredData
  attr_reader :queue

  def initialize
    @filteredData = Utf8::Symbol.all
    
    @queue = NSOperationQueue.alloc.init
    @queue.maxConcurrentOperationCount = 1
    
    notifications = NSNotificationCenter.defaultCenter
    notifications.addObserver(self, selector: 'reloadTableOnFilteredData:', name: 'filteredDataReady', object: nil)
  end

  def reloadTable
    tableView.reloadData
    tableView.selectRowIndexes(NSIndexSet.alloc.initWithIndex(0), byExtendingSelection: false)
  end

  # This method is being called by the notification center on 'filteredDataReady'
  #
  def reloadTableOnFilteredData(notification)
    self.filteredData = notification.object.filteredData
    reloadTable
  end

  # This method is being called after the Xib file has been fully loaded. The UI is now ready.
  #
  def awakeFromNib
    reloadTable
  end

  # This method is being called by NSSearchField when the user has changed the input field.
  # Don't ever fucking block the event loop!
  #
  def controlTextDidChange(notification)
    queue.cancelAllOperations
    if searchField.stringValue =~ /^\s*$/
      @filteredData = Utf8::Symbol.all
      reloadTable
    else
      search = SearchTask.alloc.initWithTerm(searchField.stringValue)
      queue.addOperation(search)
    end
  end

  # This method is being called by NSTableView on Copy CMD+C
  #
  def copy(sender)
    filteredData[tableView.selectedRow].symbol.sendToPasteboard
  end

  # This method is being called by NSTableView to ask for the number of rows it should display
  #
  def numberOfRowsInTableView(tableView)
    filteredData.size
  end

  # This method is being called by NSTableView to ask for data for each row and each column
  # A row is identified by an zero based integer index
  # Each column has an identifier, wich can be set in InterfaceBuilder
  # To make it easier, columns are identified by the corresponding getter on the Utf8::Symbol
  #
  def tableView(tableView, objectValueForTableColumn:column, row:index)
    filteredData[index].send(column.identifier)
  end
end
