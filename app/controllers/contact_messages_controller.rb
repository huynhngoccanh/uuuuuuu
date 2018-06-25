class ContactMessagesController < ApplicationController
  layout 'ubitru'

  def new
    @contact_message = ContactMessage.new
  end

  def create
    @contact_message = ContactMessage.new(params[:contact_message])

    @from_whom = current_user ? current_user : (current_vendor ? current_vendor : nil)

    if signed_in?
      cond = @contact_message.valid?
    else
      cond = @contact_message.valid? && verify_recaptcha(:model => @contact_message, :attribute => :recaptcha)
    end
    
    if cond
      if ContactMailer.contact_mail(@contact_message, @from_whom).deliver
        flash[:notice] = "Contact form has been successfully sent."
        redirect_to root_path
      else
        flash[:alert] = "Something went wrong. Please try again or contact support if the problem persists."
        redirect_to root_path
      end
    else
      flash.delete(:recaptcha_error)
      flash[:alert] = "Please fill all fields."
      render :new
    end
  end

end
