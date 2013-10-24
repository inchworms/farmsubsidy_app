# TODO move models to lib and remove that line
$LOAD_PATH << "."

require "sequel"

Sequel.extension :migration

class DatabaseCreator
  def self.create
    if system("psql -l | grep farmsubsidy_test")
      #if it is then drop the db 
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
end

DatabaseCreator.create
DatabaseCreator.migrate

require "models/year"
require "models/payment"
