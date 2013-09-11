namespace :populate do
  desc "populate payment table"
  task :payment_table do

    # connect to an in-memory database
    DB = Sequel.postgres("#{@database_name}", :loggers => [Logger.new("#{@project_root}/log/#{@database_name}_db.log")])

    beginning = Time.now

    MAXIMUMROWS = 10000

    # create a dataset from the payments table
    payment = DB[:payments]

    #create a dataset from the years table
    years = DB[:years]

    # fetch the data from DB years and create an hash
    # years.all = [{:id=>1, :year=>2000}, {:id=>2, :year=>2001}, ...]
     # {2001 => 2, 2002 => 3, 2003 => 4}
    years_hash = {}
    years.all.each do |row|
      years_hash[row[:year].to_s] = row[:id]
    end

    #create a dataset from the recipients table
    recipients = DB[:recipients]

    i = 0
    payment_txt = CSV.open("data/cz_payment.txt", "r:UTF-8", :headers => true, :col_sep => ";") do |csv|
      csv.each do |row|
          print "." if i%100 == 0

          # find the recipient_id by searching recipient dataset
          recipient_id = recipients.where(:global_recipient_id=>row['globalRecipientId']).first[:id]
          year_id      = years_hash[row['year']]
          # insert data into payments table
          payment.insert(
            amount_euro: row['amountEuro'],
            year_id: year_id,
            recipient_id: recipient_id
          )
        i += 1
        break if i > MAXIMUMROWS #(check for break in ruby)
      end
    end

    puts "For populating #{MAXIMUMROWS} rows of the payment table the Computer needs #{Time.now - beginning} seconds."
  end
end

