class LoyaltyProgramsUser < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :loyalty_program, foreign_key: :loyalty_program_id, class_name: "Merchant"
  has_many :purchase_history,  dependent: :destroy
  after_commit :fetch_detail, on: :create
  validates :account_id, :password, presence: true, if: Proc.new { |lpu| !lpu.is_signup && !lpu.is_hardcoded}
    
  before_save do
    if self.password.nil?
      self.password = user.storepassword
      self.account_id = user.email
    end
  end


  def self.fetch_details
  	LoyaltyProgramsUser.all.each do |lpu|
  		LoyaltyLoginWorker.perform_async(lpu.id)
  	end
  end

  def fetch_detail
    LoyaltyLoginWorker.perform_async(self.id)
  end

  def update_program
    LoyaltyLoginWorker.perform_async(self.id)
  end

end

#l = LoyaltyProgram.new(name: 'ACE Hardware', logo_image: File.open('/home/arkhitech/Desktop/acehardware.png'))