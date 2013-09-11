require 'csv'
require 'logger'
require "sequel"

Sequel.extension :migration

#include all .rake files in lib/tasks directory
Dir.glob('lib/tasks/*.rake').each { |r| import r }

#take the database_name variable from command line input or fall back to default: test_db
#i.e. rake db:createandmigrate database_name=xxxx  
@database_name = ENV['database_name'] || 'farmsubsidy_test_db'  


# fetch data and write to database
# these tasks MUST be run in this sequence

# Rake::Task['fetch:year_data_fetch'].invoke
# Rake::Task['fetch:recipient_data_fetch'].invoke
# Rake::Task['fetch:payment_data_fetch'].invoke
# Rake::Task['fetch:total_payments_fetch'].invoke
