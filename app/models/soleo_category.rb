class SoleoCategory < ActiveRecord::Base
  has_ancestry :cache_depth => true

  # TIRE WILL NOT BE USED -- REMOVING 20-FEB-18-22:03
  # include Tire::Model::Search

  # mapping do
  #   indexes :id, :index => :not_analyzed
  #   indexes :ancestry_depth, :index => :not_analyzed
  #   indexes :name
  # end

  def self.relevant_search(search_string)
    puts "@@@@@@@@@@@@@ search string", search_string
    search_string = Search::Intent.check_requested_query(search_string)
    puts "@@@@@@@@@@@@ search string 2", search_string.inspect
    sr = do_search search_string
    puts "@@@@@@@@@@@@@@ sr", sr.inspect
    if sr.class.name == "Tire::Results::Collection"
      puts "@@@@@@@@@@@ in the if second relevant search"
      sr = do_search "#{search_string}*" if sr.total == 0
      sr = do_search "#{search_string}", 'or' if sr.total == 0
      sr = do_search "#{search_string}*", 'or' if sr.total == 0
      result = sr.total > 0 ? sr.results[0] : nil
      puts "@@@@@@@@@@@@2 result", result.inspect
    end
  end

  def self.do_search(search_string, operator = 'AND')
    begin
      
      result = tire.search :load => true, :page => 1, :per_page => 1 do
        query { string search_string, :default_operator => operator }
        filter :term, :ancestry_depth => 4
      
      end
      rescue => e
        puts "@@@@@ in the rescue"
        Rails.logger.info "\n=============SEARCH ERROR TRACE======================\n"
        Rails.logger.info "\n Query::#{search_string} \n"
        Rails.logger.info "\n Message::#{e.message} \n"
        Rails.logger.info "\n Error Class::#{e.class} \n"
        Rails.logger.info "\n=============END OF SEARCH ERROR TRACE======================\n"
        # $notify_team.each do |developer|
        #   SearchMailer.search_error_notification(developer, e, search_string).deliver
        # end
        return []
    end
    puts "this is result baby",result
    result
  end

  def self.import_from_spreadsheet
    spreadsheet_path = Rails.root.join('public', 'soleo_category_hierarchy.xlsx').to_s
    return unless File.exist? spreadsheet_path

    puts 'Parsing spreadsheet...'

    require 'roo'
    s = Roo::Excelx.new spreadsheet_path

    SoleoCategory.connection.execute("TRUNCATE TABLE #{self.table_name}")

    puts 'Level 1: THEME'
    # root level (Soleo THEME)
    s.default_sheet = s.sheets[4]
    SoleoCategory.transaction do
      2.upto(1/0.0) do |row_n|
        if s.cell(row_n, 1).nil?
          puts 'Stopped at: ' + row_n.to_s
          break
        end
        SoleoCategory.create(:soleo_id => s.cell(row_n, 1).to_i, :name => s.cell(row_n, 2))
      end
    end

    puts 'Level 2: Internet'
    # second level (Soleo Internet)
    s.default_sheet = s.sheets[3]
    SoleoCategory.transaction do
      2.upto(1/0.0) do |row_n|
        if s.cell(row_n, 1).nil?
          puts 'Stopped at: ' + row_n.to_s
          break
        end
        parent = SoleoCategory.where(:soleo_id => s.cell(row_n, 3).to_i).at_depth(0).first
        if parent.nil?
          puts 'Parent nil. row number: ' + row_n.to_s + ', value: ' + s.cell(row_n, 3).to_i.to_s
          next
        end
        parent.children.create :soleo_id => s.cell(row_n, 1), :name => s.cell(row_n, 2)
      end
    end

    puts 'Level 3: Condenced'
    # third level (Soleo Condensed)
    s.default_sheet = s.sheets[2]
    SoleoCategory.transaction do
      2.upto(1/0.0) do |row_n|
        puts 'loop: ' + row_n.to_s if row_n % 500 == 0
        if s.cell(row_n, 1).nil?
          puts 'Stopped at: ' + row_n.to_s
          break
        end
        parent = SoleoCategory.where(:soleo_id => s.cell(row_n, 3).to_i).at_depth(1).first
        if parent.nil?
          puts 'Parent nil. row number: ' + row_n.to_s + ', value: ' + s.cell(row_n, 3).to_i.to_s
          next
        end
        parent.children.create :soleo_id => s.cell(row_n, 1), :name => s.cell(row_n, 2)
      end
    end

    puts 'Level 4: Normalized'
    # third level (Soleo Normalized)
    s.default_sheet = s.sheets[1]
    SoleoCategory.transaction do
      2.upto(1/0.0) do |row_n|
        puts 'loop: ' + row_n.to_s if row_n % 2000 == 0
        if s.cell(row_n, 1).nil?
          puts 'Stopped at: ' + row_n.to_s
          break
        end
        parent = SoleoCategory.where(:soleo_id => s.cell(row_n, 3).to_i).at_depth(2).first
        if parent.nil?
          puts 'Parent nil. row number: ' + row_n.to_s + ', value: ' + s.cell(row_n, 3).to_i.to_s
          next
        end
        parent.children.create :soleo_id => s.cell(row_n, 1), :name => s.cell(row_n, 2)
      end
    end

    puts 'Level 5: Raw'
    # third level (Soleo Raw)
    s.default_sheet = s.sheets[0]
    SoleoCategory.transaction do
      2.upto(1/0.0) do |row_n|
        puts 'loop: ' + row_n.to_s if row_n % 5000 == 0
        if s.cell(row_n, 1).nil?
          puts 'Stopped at: ' + row_n.to_s
          break
        end
        parent = SoleoCategory.where(:soleo_id => s.cell(row_n, 3).to_i).at_depth(3).first
        if parent.nil?
          puts 'Parent nil. row number: ' + row_n.to_s + ', value: ' + s.cell(row_n, 3).to_i.to_s
          next
        end
        parent.children.create :soleo_id => s.cell(row_n, 1), :name => s.cell(row_n, 2)
      end
    end

    puts 'Indexing...'
    SoleoCategory.index.delete
    SoleoCategory.import
  end
end
