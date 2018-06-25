class Admins::QueryController < Admins::ApplicationController


def index
	@queries = Sunspot.search(Facebookquery)do
		order_by(:created_at,:desc)		
	end.results

	
end

end