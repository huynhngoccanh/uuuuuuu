class Users::SurveysController < ApplicationController

  def index

  end

  def new
    unless current_user.survey.nil?
      redirect_to :action=>:edit
      return
    end
    @survey = current_user.build_survey {}
  end

  def edit
    if current_user.survey.nil?
      redirect_to :action=>:new 
      return
    end
    @survey = current_user.survey
  end

  def create
    @survey = current_user.build_survey(params[:survey])

    if @survey.save
      if(params[:no_social])
        redirect_to url_for(:controller=>'/users', :action=>'dashboard'), :notice => 'Thank you for completing the wizard.'
      else
        redirect_to url_for(:controller=>'users/profile', :action=>'show'), :notice => 'Thank you for completing the wizard.'
      end
    else
      render :action => "new"
    end
  end

  def update
    @survey = current_user.survey

    if @survey.update_attributes(params[:survey])
      if(params[:no_social])
        redirect_to url_for(:controller=>'/users', :action=>'dashboard'), :notice => 'Thank you for completing the wizard.'
      else
        redirect_to url_for(:controller=>'users/profile', :action=>'show'), :notice => 'Thank you for completing the wizard.'
      end
    else
      render :action => "edit"
    end
  end
end
