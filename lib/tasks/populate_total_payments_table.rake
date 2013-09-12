namespace :populate do
  desc "calculate total payments and populate table"
  task :total_payments_table do

    # connect to an in-memory database
    DB = Sequel.postgres("#{@database_name}", :loggers => LOGGERS)

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

    # look trought all recipients and all years and get the total amount
    Recipient.all.each do |recipient|
      Year.all.each do |year|
        total = recipient.total_payment_amount_per_year(year.year)
        if total != 0.0
          total_payment.insert(
            recipient_id: recipient.id,
            year_id: year.id,
            amount_euro: total
            )
        end
      end
    end

    puts "\nFor calculating total payments the Computer needs #{Time.now - beginning} seconds."
  end
end

