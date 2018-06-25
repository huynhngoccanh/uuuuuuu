class LoyaltyLoginWorker
	include Sidekiq::Worker

	sidekiq_options retry: false

	def perform(loyalty_programs_user_id)
		loyalty_programs_user = LoyaltyProgramsUser.find(loyalty_programs_user_id)
		if loyalty_programs_user.is_signup
			(loyalty_programs_user.loyalty_program.loyalty_class).constantize.new(loyalty_programs_user).signup
		else
			(loyalty_programs_user.loyalty_program.loyalty_class).constantize.new(loyalty_programs_user).get_history
		end
	end

end