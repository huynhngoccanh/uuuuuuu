class Taxon < ActiveRecord::Base
	scope :root, -> { where('parent_id is null') }
	belongs_to :taxonomy
	before_save :update_nested_name
	belongs_to :parent, class_name: "Taxon", foreign_key: :parent_id
	has_many :descendants, class_name: "Taxon", foreign_key: :parent_id
	has_many :merchant_taxons
	has_many :merchants, through: :merchant_taxons
	after_save :reindex_merchant

	searchable do
    	integer :id
    	integer :parent_id
    	text :name
  	end
	
	
  	def taxons 
  		@taxons_all = self.descendants
  		@taxons_all.each do |taxon|
  			@taxons_all += taxon.descendants
  		end
  		@taxons_all 
  	end



	def self.most_popular
		obj = {}
  	where(in_popular_store: true).order("name asc").includes(:merchants).each do |taxon|
  		char = taxon.name[0].upcase
  		if obj[char].blank?
  			obj[char] = [taxon]
  		else
  			obj[char] << taxon
  		end
  		
  	end
  	obj
  end

  def self.total_items
  	i = 0
  	most_popular.each do |c, taxons|
  		i = i + 1
  		taxons.each do |taxon|
  			i = i + 1
  			taxon.merchants.each do |merchant|
  				i = i + 1
  			end
  		end
  	end
  	i
  end

	def self_and_ancestors
		ancestors = []
		current_obj = self
		while current_obj.present?
			ancestors << current_obj
			current_obj = current_obj.parent
		end
		ancestors
	end

	def seo_title
		self_and_ancestors.collect(&:name).reverse.join(" - ") + ""
	end

	def self.parse
	  obj = {}
	  @current_parent = nil
	  @current_sub_parent = nil
		Roo::Spreadsheet.open("db/taxonomy.ods").sheet('Sheet1').each_with_index do |s, i|
			if i > 2
				unless s[0].blank?
					@current_parent = Taxon.create(name: s[0], parent_id: nil, taxonomy_id: 1)
				else
					unless s[1].blank?
						@current_sub_parent = Taxon.create(name: s[1], parent_id: @current_parent.id, taxonomy_id: 1)
					else
						unless s[2].blank?
							Taxon.create(name: s[2], parent_id: @current_sub_parent.id, taxonomy_id: 1)
						end
					end
				end
			end
		end
		obj
	end

	private

		def update_nested_name
			nested_name_arr = []
			current_obj = self
			while current_obj.present?
				nested_name_arr << current_obj.name.parameterize
				current_obj = current_obj.parent
			end
			self.nested_name = nested_name_arr.reverse.join("/")
		end

	  def reindex_merchant
	  	merchants.each do |merchant|
	  		Sunspot.index(merchant)
	  	end
	  	true
	  end
		
end