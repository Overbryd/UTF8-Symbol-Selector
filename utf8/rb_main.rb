#
#  rb_main.rb
#  utf8
#
#  Created by Lukas Rieder on 2/2/12.
#  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'Cocoa'

# Loading all the Ruby project files.
main = File.basename(__FILE__, File.extname(__FILE__))
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  if path != main
    require(path)
  end
end

require 'string_ext'
require 'rubygems'

Utf8::Symbol.loadFromFile File.join(dir_path, 'symbols.marshal')

begin
  raise 'picky does not work yet'
  require 'picky'

  Utf8Index = Picky::Index.new(:utf8_index) do
    source { Utf8::Symbol.all }
    indexing removes_characters: /[^a-z0-9\-\s\"\~\*\:\,]/i,
             splits_text_on: /[\s\-]/
    category :description
  end
  Utf8Search = Picky::Search.new(Utf8Index) do
    searching removes_characters: /[^a-z0-9\-\s\/\_\&\.\"\~\*\:\,]/i, # Picky needs control chars *"~:, to pass through.
              stopwords:          /\b(and|the|of|it|in|for)\b/i,
              splits_text_on:     /[\s\/\-\&]+/
  end
  Utf8Index.load rescue Utf8Index.index
rescue
  puts 'Using Sqlite3 w/ FTS'
  require 'sqlite3'
  
  db_path = File.join(dir_path, 'symbols.sqlite3')
  DB = SQLite3::Database.new(db_path)
  
  unless File.exist?(db_path)
    puts 'No index exists, creating a new index table'
    DB.execute("CREATE VIRTUAL TABLE idx USING fts3(content TEXT);") 
    DB.execute("CREATE VIRTUAL TABLE symbols USING fts3(id, symbol, bytecode, html_entity, description);") 
    Utf8.data.each do |symbol|
      DB.execute("INSERT INTO symbols (#{symbol.members.join(', ')}) VALUES (#{symbol.members.fill('?').join(', ')})", symbol.values)
    end
    puts 'Indexing complete'
  end
end

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
