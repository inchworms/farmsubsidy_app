#include all .rake files in lib/tasks directory
Dir.glob('lib/tasks/*.rake').each { |r| import r }

#take the database_name variable from command line input:
#i.e. rake db:createandmigrate database_name=xxxx
database_name = ENV['database_name']

# create and migrate new database
namespace :db do 
  desc 'create and migrate database'
  task :createandmigrate do
    require "sequel"
    Sequel.extension :migration

    #check to see if performance DB already exists
    the_database_is_there = system("psql -l | grep #{database_name}")
    if the_database_is_there
      #if it does then drop the db 
      system("dropdb #{database_name}")
    end

    DB = Sequel.postgres("#{database_name}")
    Sequel::Migrator.run(DB, './db/migrations', :use_transactions=>true)
  end

 

  # fetch data and write to database
  # these tasks MUST be run in this sequence
  
  # Rake::Task['fetch:year_data_fetch'].invoke
  # Rake::Task['fetch:recipient_data_fetch'].invoke
  # Rake::Task['fetch:payment_data_fetch'].invoke
  # Rake::Task['fetch:total_payments_fetch'].invoke
end

# create csv files
namespace :csv do
  task :create_total_payment do
    # gets the project root
    tasks_dir = File.dirname(File.absolute_path(__FILE__))
    project_root = tasks_dir.gsub(/lib\/tasks/,"")

    Rake::Task['csv:create_total_payment'].invoke
  end
end

