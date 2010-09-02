module ActionMailer
  class Queue < ActionMailer::Base

    @@table_name = 'emails'
    cattr_accessor :table_name
    
    @@delivery_method = :action_mailer_queue
    cattr_accessor :delivery_method
  
    @@limit_for_processing = 100
    cattr_accessor :limit_for_processing
    
    @@max_attempts_in_process = 5
    cattr_accessor :max_attempts_in_process
    
    @@delay_between_attempts_in_process = 240
    cattr_accessor :delay_between_attempts_in_process
  
    def self.queue
      return new.queue
    end
  
    def queue
      return Store.create_by_table_name(ActionMailer::Queue.table_name)
    end
  
    def perform_delivery_action_mailer_queue(mail)
      store = self.queue.new(:tmail => mail, :method =>  "#{mailer_name}.#{@template}")
      store.save
      mail.queue_id = store.id
      return true
    end
 
  end
end