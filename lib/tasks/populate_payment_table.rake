namespace :populate do
  desc "populate payment table"
  task :payment_table do

    # connect to an in-memory database
    unless defined?(DB)
      DB = Sequel.postgres("#{DATABASE_NAME}", :loggers => LOGGERS) 
    end

    beginning = Time.now

    MAXIMUMROWS = 1000000

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
    input_file_path = "#{DOCUMENT_ROOT}/data/#{PAYMENTS_FILE_NAME}"

    puts "\n\nNow populating the payments table."

    CSV.foreach(input_file_path, col_sep: ";", headers: true, encoding: "UTF-8") do |row|
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

    puts "\nFor populating #{i} rows of the payment table the Computer needs #{Time.now - beginning} seconds."
  end
end

