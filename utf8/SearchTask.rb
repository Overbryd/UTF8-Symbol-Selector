class SearchTask < NSOperation
  attr_reader :term, :filteredData
  
  def initWithTerm(term)
    init
    @term = term
    self
  end
  
  def main
    @filteredData = Utf8::Symbol.search(term)
    NSNotificationCenter.defaultCenter.postNotificationName('filteredDataReady', object: self)
  end
end
