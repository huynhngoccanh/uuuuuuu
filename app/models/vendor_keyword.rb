class VendorKeyword < ActiveRecord::Base
  
  belongs_to :vendor
  
  validates :vendor_id, :presence=>true
  validates :keyword, :presence=>true, :uniqueness =>{ :scope => :vendor_id }
  
  attr_accessible :keyword
  
  scope :search, lambda {|s|  
    unless s.blank?
      where('vendor_keywords.keyword LIKE ?', "%#{s}%")
    else
      self
    end
  }
  
  def self.add_from_adwords_csv_content content, vendor
    return false if content.blank?
    
    added_keywords_number = 0
    duplicate_keywords_number = 0
    
    rows = content.split(/\n/)
    
    multi_column = false
    separator = false
    line_offset = 0
    [",","\t"].each do |sep|
      if rows[1].nil?
        if rows[0].split(sep).length > 1
          multi_column = true
          separator = sep
          break
        end
      else
        if rows[1].split(sep).length > 1
          multi_column = true
          separator = sep
          line_offset = 1 unless rows[0].split(sep).length > 1
          break
        end
      end
    end
    
    use_column = nil
    rows.each_with_index do |row, idx|
      next if idx < line_offset
      next if row =~ /Keyword report/ #skip th header line
      
      if multi_column
        columns = row.split(separator)
        if !use_column #read header information
          columns.each_with_index do |header, i|
            use_column = i if header.strip =~ /^keywords?$/i
          end
          use_column = 0 if use_column.blank?
          next
        else
          keyword = columns[use_column].strip
          keyword = keyword.gsub(/^"(.*)"$/, '\1') #strip csv quotings
          keyword = keyword.gsub(/""/, '"') #unescape double quotes
        end
      else
        keyword = row.strip
        next if idx == line_offset && keyword =~ /^keywords?$/i #skip header line
      end
      
      keyword = keyword.strip.gsub(/^"(.*)"$/, '\1').gsub(/^\[(.*)\]$/, '\1').gsub(/^\[(.*)\]$/, '\1').gsub(/\+(\S)/,'\1')
      keyword = keyword.strip
      
      next if keyword == '--' || keyword.blank?
      
      k = self.new 
      k.vendor_id = vendor.id
      k.keyword = keyword
      
      if k.save
        added_keywords_number += 1
      else
        duplicate_keywords_number += 1
      end
    end
    
    
    return added_keywords_number, duplicate_keywords_number
  rescue
    return false
  end
end
