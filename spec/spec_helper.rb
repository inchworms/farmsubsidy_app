# TODO move models to lib and remove that line
$LOAD_PATH << "."

require "sequel"

class DatabaseCreator
  def self.create
    if system("psql -l | grep farmsubsidy_test")
      #if it is then drop the db 
      system("dropdb farmsubsidy_test")
    end
    system("createdb farmsubsidy_test")
  end
end

DatabaseCreator.create

# connect to an in-memory database
# TODO: new Database test
DB = Sequel.postgres("farmsubsidy_test")

require "models/year"
require "models/payment"