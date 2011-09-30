class PaymentStreamController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:moip]

  # this action receive a post request from moip service.
  def moip
    moip_request = PaymentHistory::Moip.new(params).process_request!
    return render :nothing => true, :status => moip_request.response_code
  end

  def thank_you
    unless session[:thank_you_id]
      flash[:failure] = I18n.t('payment_stream.thank_you.error')
      return redirect_to :root
    end

    @project = Project.find session[:thank_you_id]
    @title = t('payment_stream.thank_you.title')
    session[:thank_you_id] = nil
  end
end