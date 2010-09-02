class Notifier < Email
  include SendGrid
  def admin_invite_notification(contact)
    setup_email(contact)
    @bcc = Settings.developers_emails
    @subject    = 'You are invited!'
    @body[:url]  = "http://#{SITE_URL}/"
  end

  def forgot_password_notification(contact)
    setup_email(contact)
    @bcc = Settings.developers_emails
    @subject    = 'NameFrame - Your Password Has Been Recovered !'
    @body[:url]  = "http://#{SITE_URL}/"
  end


  def order_confirm_email(checkout)
    @subject = '[NameFrame]Your Order Has Been Successfully Placed'
    @recipients = checkout.email
    @bcc = Settings.developers_emails
    @from = 'admin@nameframe.com'
    @content_type = "text/html"
    @sent_on     = Time.now
    @body[:checkout] = checkout
  end
  
  def order_notification_email(checkout)
    @subject = "Order No. #{checkout.order_number}"
    @recipients = Settings.orders_email
    @bcc = Settings.developers_emails
    @from = 'admin@nameframe.com'
    @content_type = "multipart/mixed"
    @sent_on     = Time.now

    part :content_type => "multipart/alternative" do |a|
      a.part "text/html" do |p|
        p.body = render_message 'order_notification_email.html.erb', :checkout => checkout
      end
    end
    attachment :content_type => "image/jpeg", :body => File.read("#{checkout.nameframe.get_public_path}#{checkout.nameframe.get_image_path}")
    attachment :content_type => "image/jpeg", :body => File.read("#{checkout.nameframe.get_public_path}#{checkout.nameframe.flex_address_path}") unless checkout.nameframe.flex_address.blank?
  end

  protected

  def setup_email(contact)
    #      puts "?????? #{contact.email}"
    @recipients  = contact.email
    @from        = "admin@nameframe.com"
    @sent_on     = Time.now
    @content_type = "text/html"
    @body[:contact] = contact
  end

end
