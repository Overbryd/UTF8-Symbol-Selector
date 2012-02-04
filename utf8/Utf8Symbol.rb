module Utf8
  attr_accessor :data
  
  class Symbol < Struct.new(:id, :symbol, :bytecode, :html_entity, :description)
    def self.loadFromFile(path)
      Utf8.data = Marshal.load(File.read(path))
    end
    
    def self.all
      Utf8.data
    end
    
    def self.search(term)
      # All queries end up like this
      # I found out using the utf8 descriptions this yielded the best results
      # Mo => Mo*
      # Evi Mo => Evi* Mo*
      #
      query = term.gsub(/[^A-Za-z0-9 ]/, '').split(' ').join('* ').concat('*')
      DB.execute("SELECT * FROM symbols WHERE symbols MATCH ?;", [query]).map do |attributes|
        Utf8.data[attributes[0]]
      end
    end
  end
  extend self
end
