namespace :fetch do
  desc "fetch recipient data and populate table"
  task :recipient_data_fetch do

    require 'csv'
    require 'rubygems'
    require 'sequel'
    require 'logger'

    # connect to an in-memory database
    DB = Sequel.postgres("#{database_name}", :loggers => [Logger.new($stdout)])

    beginning = Time.now

    # create a dataset from the recipient data
    recipient = DB[:recipients]
    i = 0
    recipient_txt = CSV.read("data/cz_recipient.txt", "r:UTF-8", :headers => true, :col_sep => ";") do |csv|
      csv.each do |row|
          print "." if i%100 == 0
          recipient.insert(
            global_recipient_id: row['globalRecipientId'],
            zipcode: row['zipcode'],
            name: row['name']
          )
        i += 1
      end
    end

    puts "For populating recipients table the Computer needs #{Time.now - beginning} seconds."
  end
end


