class Api::V1::AutocompletesController < Api::V1::ApplicationController

	def search
    @merchants = Sunspot.search(Merchant) do
      any do
        fulltext "#{params[:q]}*", :fields => :name do
          query_phrase_slop 1
        end
        with(:browsablestore, true)
        with(:active_status, true)
      end
    end.results 
    
        @merchants += Sunspot.search(Merchant) do
          fulltext "#{params[:q]} *" || "#{params[:q]}*", :fields => :name do
            phrase_fields :name => 2.0
            phrase_slop   1
          end
          with(:active_status, true)
      end.results
        @merchants += Sunspot.search(Merchant) do
          fulltext "#{params[:q]}*", :fields => :name do
            phrase_fields :name => 2.0
            phrase_slop   1
          end
          with(:active_status, true)
      end.results 

      @result = []
      @merchants.each do |mer|
        if mer.name.downcase.start_with?("#{params[:q].downcase}") 
          @result.push(mer)
        end
      end
      if @result.blank?|| @result.length <5
        @merchants.each do |mer|
          if mer.name.downcase.include?("#{params[:q]}")
            @result.push(mer)
          end
        end
      end


    render json: @result.uniq.as_json({
      only: [:name, :slug, :id]
    })

  end

  def services
    @taxons = Taxon.where("name like '%#{params[:q]}%'").where(taxonomy_id: 2)
    render json: @taxons.as_json({
      only: [:name, :id]
    })
  end
  
end