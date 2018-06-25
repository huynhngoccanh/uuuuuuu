class InviteUser < ActiveRecord::Base

  # / -------------------------Association----------------------

  belongs_to :user

  # / --------------------------Validation----------------------

  validate :check_invitation ,on: :create
  validates :email, presence: true

  # / --------------------------CallBacks-----------------------

  after_create :invite_mail


  # / --------------------------Methods-------------------------
  # ------------------------------to get invited_user's id-------------------
  def invite_user_id
    User.find_by_email(self.email).try(:id)
  end
  # -------------------------------user's created_date--------------------------------
  def created_date
    User.find_by_email(self.email).try(:created_at)
  end
  # ===============================all services clicked by invited user---------------------
  def service
    ServiceRequest.where(user_id: invite_user_id, created_at: created_date..created_date+31535999).all
  end
  # -------------------------------------10% amount bonus for main user.........................
  def service_request_amount
    service.sum(:cashback).to_f*0.1
  end




  def all_clicks_amount
    Click.where(user_id: invite_user_id,created_at: created_date..created_date+31535999).all.sum(:cashback_amount).to_f*0.1
  end

  private
  def check_invitation
    invite_user = InviteUser.where(user_id: self.user_id, email: self.email)
    if invite_user.last
      self.errors.add(:base, "Invitation is Already sent")
    end

    if self.email == self.user.email
      self.errors.add(:base, "You can't invite yourself")
    end
  end

  def invite_mail
    ReferralsMailer.invite(user, self.email).deliver
  end
end
