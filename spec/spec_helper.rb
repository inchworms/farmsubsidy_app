# TODO move models to lib and remove that line
$LOAD_PATH << "."

require "sequel"
require 'csv'

Sequel.extension :migration

class Database
  def self.create
    if system("psql -l | grep farmsubsidy_test")
      # if it is then drop the db
      system("dropdb farmsubsidy_test")
    end
    system("createdb farmsubsidy_test")
  end

  def self.migrate
    # connect to an in-memory database
    # no constant creation in methods!!!!
    db = Sequel.postgres("farmsubsidy_test")
    Sequel::Migrator.run(db, "db/migrations", :use_transactions=>true)
  end

  def self.populate_year_table
    # connect to an in-memory database
    # no constant creation in methods!!!!
    db = Sequel.postgres("farmsubsidy_test")
    year = db[:years]

    years_array = [2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012]
    years_array.each do |x|
      year.insert(
        year: [x]
      )
    end
  end

  def self.populate_recipient_table
    db = Sequel.postgres("farmsubsidy_test")
    recipient = db[:recipients]

    i = 0

    CSV.foreach("data/cz_recipient.txt", col_sep: ";", headers: true, encoding: "UTF-8") do |row|
      print "." if i%100 == 0
      recipient.insert(
        global_recipient_id: row['globalRecipientId'],
        zipcode: row['zipcode'],
        name: row['name'])
      i += 1
      break if i > 10
    end
  end

  def self.populate_payment_table
    db = Sequel.postgres("farmsubsidy_test")
    payment = db[:payments]
    years = db[:years]
    recipients = db[:recipients]

    # fetch the data from DB years and create an hash
    # years.all = [{:id=>1, :year=>2000}, {:id=>2, :year=>2001}, ...]
     # {2001 => 2, 2002 => 3, 2003 => 4}
    years_hash = {}
    years.all.each do |row|
      years_hash[row[:year].to_s] = row[:id]
    end

    i = 0

    CSV.foreach("data/cz_payment.txt", col_sep: ";", headers: true, encoding: "UTF-8") do |row|

      recipients.all.each do |recipient|
        if recipient[:global_recipient_id] == row['globalRecipientId']
          recipient_id = recipients.where(:global_recipient_id=>row['globalRecipientId']).first[:id]
          year_id      = years_hash[row['year']]
          payment.insert(
            amount_euro: row['amountEuro'],
            year_id: year_id,
            recipient_id: recipient_id
          )
        end
      end
      i += 1
      break if i > 100
    end
  end
end

Database.create
Database.migrate
Database.populate_year_table
Database.populate_recipient_table
Database.populate_payment_table

require "models/year"
require "models/recipient"
require "models/payment"
