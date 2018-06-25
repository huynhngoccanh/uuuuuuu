task :import_stores_locations => :environment do

require 'roo'
  ##################
  
  
xlsx = Roo::Spreadsheet.open('/home/arkhitech/Desktop/Untitled Folder/Sears.xlsx', extension: :xlsx)

xlsx.info  
  
  

#File.open("/home/arkhitech/Desktop/Untitled Folder/Sears.xlsx", "r").each do |line|
#serial, price = line.strip.split("\t")
#puts price
#
#end

  
  #####################

end

