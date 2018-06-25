require 'open-uri'
require 'net/http'
class Api::V1::TaxonsController < Api::V1::ApplicationController

	def search
		begin
			if params[:taxon_id].blank?
				keyword = URI::encode(params[:q].gsub('&', ''))
			else
				keyword = URI::encode(Taxon.where(id: params[:taxon_id]).last.name.gsub('&', ''))
			end
			url = "https://api.soleo.com/sponsored?Sort=value&Keyword=#{keyword}&PostalCode=#{params[:zip]}&APIKey=eraq8qd69saakuun9pnrpjam"
			result = JSON.parse(open(url).read)["businesses"].collect do |business|
				{
					name: business["name"],
					cashback: ActionController::Base.helpers.number_to_currency((business["monetizationCritera"]["value"].to_f/3.0)),
					link: business["_links"].last["href"]
				}
			end
			render json: result
		rescue Exception => e
			p e
			render json:[]
		end
	end

	def get_number
		begin
		@service_request = ServiceRequest.create(presented_link: params[:href], user_id: current_user.try(:id))
		resp_presented = Net::HTTP.post_form(URI.parse(@service_request.presented_link), {})
		resp_selected = Net::HTTP.post_form(URI.parse(JSON.parse(resp_presented.body)["data"].first["_links"].first["href"]), {})
		resp_getcompletionnumber = JSON.parse(open(URI.parse(JSON.parse(resp_selected.body)["data"].first["_links"].last["href"])).read)
		@service_request.update_attributes(completetion_number: resp_getcompletionnumber["data"].first["completionPhoneNumber"], completion_callback: resp_getcompletionnumber["data"].first["_links"].last["href"], keyword: params[:keyword], cashback: params[:cashback].gsub("$"," ").to_f, zip: params[:zip] )
		Net::HTTP.post_form(URI.parse(@service_request.completion_callback), {})
		render json: {
			number: @service_request.completetion_number
		}
		rescue
			render json: {
				number: "unavailable!"
			}
		end
	end
  
end