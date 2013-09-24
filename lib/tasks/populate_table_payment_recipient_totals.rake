namespace :populate do
  desc "calculate total payments per recipient for all years and populate table"
  task :payment_recipient_totals_table do

    # connect to an in-memory database
    unless defined?(DB)
      DB = Sequel.postgres("#{DATABASE_NAME}", :loggers => LOGGERS)
    end

    beginning = Time.now

    # connect to the models

    # __FILE__ is a reference to the current file name
    # absolute_path converts a pathname to an absolute pathname
    # File.dirname gets the directory
    tasks_dir = File.dirname(File.absolute_path(__FILE__))
    
    # substitudes "lib" and "tasks" to get to the project directory
    project_root = tasks_dir.gsub(/lib\/tasks/,"")
    Dir.glob(project_root + "/models/*.rb").each{|f| require f}

    # connect to payments total table and add data to the database
    payment_recipient_totals = DB[:payment_recipient_totals]

    i = 0

    puts "\n\nNow populating the payment_recipient_totals table."

    # look trought all recipients and all years and get the total amount
    Recipient.all.each do |recipient|
      print "." if i%100 == 0
      total = recipient.total_payments_by_recipient(recipient.id)
      payment_recipient_totals.insert(
        recipient_id: recipient.id,
        amount_euro: total
        )
      i += 1
    end

    puts "\nFor calculating total payments per recipients the Computer needs #{Time.now - beginning} seconds."
  end
end

