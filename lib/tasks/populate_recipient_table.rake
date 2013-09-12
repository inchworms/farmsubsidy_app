namespace :populate do
  desc "populate recipient table"
  task :recipient_table do

    # connect to an in-memory database
    DB = Sequel.postgres("#{@database_name}", :loggers => [Logger.new("#{@project_root}/log/#{@database_name}_db.log")])
    
    beginning = Time.now

    # create a dataset from the recipient data
    recipient = DB[:recipients]
    
    i = 0              
    input_file_path = "#{@project_root}/data/cz_recipient.txt"

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


