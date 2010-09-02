begin
p "one"
Email.queue.process!
rescue Exception => e
p "rescue"
p e
## your rescue code here
end