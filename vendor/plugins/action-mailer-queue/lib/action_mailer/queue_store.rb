module ActionMailer
  class Queue < ActionMailer::Base
    class Store < ActiveRecord::Base
    
      named_scope :for_send, :conditions => [ "sent = ?", false]
      named_scope :already_sent, :conditions => [ "sent = ?", true]

      named_scope :with_processing_rules, lambda {{
        :conditions => [ "attempts < ? AND (last_attempt_at < ? OR last_attempt_at IS NULL)", ActionMailer::Queue.max_attempts_in_process, Time.now - ActionMailer::Queue.delay_between_attempts_in_process.minutes], 
        :limit => ActionMailer::Queue.limit_for_processing,
        :order => "priority asc, last_attempt_at asc"
      }}
      named_scope :with_error, :conditions => ["attempts > ?", 0]
      named_scope :without_error, :conditions => ["attempts = ?", 0]
    
      class MailAlreadySent < StandardError; end 
      class MailInProgress < StandardError; end 
    
      def self.create_by_table_name(table_name)
        self.set_table_name table_name
        return self
      end
    
      def self.process!(options = {})
        p "Hello"
        self.for_send.with_processing_rules(:all, options).each { |q| q.deliver! }
      end
    
      def tmail=(mail)
        self.to = mail['to'].to_s
        self.cc = mail['cc'].to_s
        self.bcc = mail['bcc'].to_s 
        self.reply_to = mail['reply_to'].to_s
        self.from = mail['from'].to_s
        self.subject = mail.subject unless mail.subject.blank?     
        self.content = mail.encoded
      end
    
      def to_tmail
        tmail = TMail::Mail.parse(self.content)
        tmail.to = self.to.split(",") unless self.to.blank?
        tmail.cc = self.cc.split(",") unless self.cc.blank?
        tmail.bcc = self.bcc.split(",") unless self.bcc.blank?
        tmail.reply_to = self.reply_to.split(",") unless self.reply_to.blank?
        tmail.from = self.from.split(",") unless self.from.blank?
        tmail.subject = self.subject unless self.subject.blank?
        tmail.content_type = "text/html"
        return tmail
      end
    
      def resend!
        self.sent = false
        self.save
        self.deliver!
      end
    
      def deliver!
        self.reload
        raise MailAlreadySent if self.sent?
        raise MailInProgress if self.in_progress?
        self.update_attribute(:in_progress, true)
        mail = Mailer.deliver(self.to_tmail)
        self.message_id = mail.message_id
        self.sent = true
        self.sent_at = Time.now
        self.in_progress = false
        self.save
        return mail
      rescue => err
        raise MailAlreadySent if err.class == ActionMailer::Queue::Store::MailAlreadySent 
        self.attempts += 1
        self.last_error = err.to_s
        self.last_attempt_at = Time.now
        self.in_progress = false
        self.save
        return false
      end
    
    end
  end  
end