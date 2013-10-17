# TODO move models to lib and remove that line
$LOAD_PATH << "."

require "sequel"

# connect to an in-memory database
# TODO: new Database test
DB = Sequel.postgres("farmsubsidy_development")

require "models/year"
