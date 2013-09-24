namespace :populate do
  desc "calculate total payments per year and recipient and populate table"
  task :payment_year_totals_table do

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
    total_payment = DB[:payment_year_totals]

    i = 0

    puts "\n\nNow populating the total_payments table."

    # look trought all recipients and all years and get the total amount
    Recipient.all.each do |recipient|
      Year.all.each do |year|
        print "." if i%100 == 0
        total = recipient.total_payment_amount_per_year(year.year)
        if total != 0.0
          total_payment.insert(
            recipient_id: recipient.id,
            year_id: year.id,
            amount_euro: total
            )
        end
      end
      i += 1
    end

    puts "\nFor calculating total payments the Computer needs #{Time.now - beginning} seconds."
  end
end

