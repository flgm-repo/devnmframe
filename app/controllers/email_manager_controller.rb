class EmailManagerController < ApplicationController
  
  def invite(to)
    if Notifier.deliver_admin_invite_notification(to)
      flash[:notice] = "Invitation request has been sent to the contact!"
    else
      flash[:notice] = "There is some problem with the server please contact Administrator"
      return
    end
  end

  def deliver
    Mailing.update(params[:id], :scheduled_at => Time.now)
    flash[:notice] = "Delivering mailing"
    redirect_to mailings_url
  end

  
end