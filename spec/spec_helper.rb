# TODO move models to lib and remove that line
$LOAD_PATH << "."

require "sequel"

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
end

Database.create
Database.migrate
Database.populate_year_table

require "models/year"
require "models/payment"
