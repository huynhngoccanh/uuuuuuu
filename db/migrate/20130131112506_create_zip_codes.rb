class CreateZipCodes < ActiveRecord::Migration
  def change
    create_table :zip_codes do |t|
      t.string :code
      t.float :lat
      t.float :lng
      t.timestamps
    end

    add_index :zip_codes, :code, :unique => true
  end
end

=begin
code to import the csv file to database

first = true
CSV.foreach('tmp/zip_code_database.csv', :headers => false) do |row|
  if first
    first = false
    next 
  end
  ZipCode.create({
      :code=>row[0],
      :lat=>row[9],
      :lng=>row[10]
    })
end
=end
