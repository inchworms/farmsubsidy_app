require 'csv'
require 'logger'
require "sequel"

Sequel.extension :migration

#include all .rake files in lib/tasks directory
Dir.glob('lib/tasks/*.rake').each { |r| import r }

#take the database_name variable from command line input or fall back to default: test_db
#i.e. rake db:createandmigrate database_name=xxxx  
DATABASE_NAME = ENV['database_name'] || 'farmsubsidy_development'
DOCUMENT_ROOT = File.dirname(File.absolute_path(__FILE__))

RECIPIENT_FILE_NAME = 'cz_recipient.txt'
PAYMENTS_FILE_NAME  = 'cz_payment.txt'
                                                                
                                                                
# logging is optional
# LOGGERS = [Logger.new("#{@project_root}/log/#{@database_name}_db.log")]
LOGGERS = []

# fetch data and write to database
# these tasks MUST be run in this sequence
desc 'delete and (re-)create db, read data from CSVs into db'
task 'prepare_data' do

  user_message  = "This task will delete the db '#{DATABASE_NAME}' and re-create it."+"\n" 
  user_message += "It will parse the CSV-Files in /data and put the data into the database."+"\n"
  user_message += "Hit [Enter] if that is OK for you, else hit [Ctrl]+C."+"\n"

  STDOUT.puts user_message
  # just wait for any input to stop script execution
  input = STDIN.gets.chomp

  beginning = Time.now

  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
  Rake::Task['populate:year_table'].invoke
  Rake::Task['populate:recipient_table'].invoke
  Rake::Task['populate:payment_table'].invoke
  Rake::Task['populate:total_payments_table'].invoke

  puts "Setting up the complete data took: #{Time.now - beginning} seconds."
end