namespace :populate do
  desc "populate recipient table"
  task :recipient_table do

    # connect to an in-memory database
    unless defined?(DB)
      DB = Sequel.postgres("#{DATABASE_NAME}", :loggers => LOGGERS) 
    end
    
    beginning = Time.now

    # create a dataset from the recipient data
    recipient = DB[:recipients]
    
    i = 0              

    input_file_path = "#{DOCUMENT_ROOT}/data/#{RECIPIENT_FILE_NAME}"

    puts "\n\nNow populating the recipients table."

    CSV.foreach(input_file_path, col_sep: ";", headers: true, encoding: "UTF-8") do |row|
      print "." if i%100 == 0
      recipient.insert(
        global_recipient_id: row['globalRecipientId'],
        zipcode: row['zipcode'],
        name: row['name'])
      i += 1
    end

    puts "\nFor populating recipients table the Computer needs #{Time.now - beginning} seconds."
  end
end


