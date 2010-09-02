#Cronjob  to remove The old nameframes 
set :environment, Rails.env
every :saturday, :at => "4:00am"  do
    runner "Nameframe.remove_old_saved_jobs",  :output => {:error => 'cron_error.log', :standard => 'cron_std.log'}
  end
