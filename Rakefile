# create and migrate new database
namespace :db do 
  task :createandmigrate do
    require "sequel"
    Sequel.extension :migration

    #check to see if performance DB already exists
    the_database_is_there = system("psql -l | grep farmsubsidy_development")
    if the_database_is_there
      #if it does then drop the db 
      system("dropdb farmsubsidy_development")
    end
    #and recreate it
    system("createdb farmsubsidy_development")

    DB = Sequel.postgres("farmsubsidy_development")
    Sequel::Migrator.run(DB, './db/migrations', :use_transactions=>true)
  end

  # fetch data and write to database
  task :fetchdata do
    # gets the project root
    tasks_dir = File.dirname(File.absolute_path(__FILE__))
    project_root = tasks_dir.gsub(/lib\/tasks/,"")

    system("ruby #{project_root}/lib/tasks/year_data_fetch.rb")
    system("ruby #{project_root}/lib/tasks/recipients_data_fetch.rb")
    system("ruby #{project_root}/lib/tasks/payments_data_fetch.rb")
    system("ruby #{project_root}/lib/tasks/total_payments_data_fetch.rb")
  end
end

# create csv files
namespace :csv do
  task :createtotalpayment do
    # gets the project root
    tasks_dir = File.dirname(File.absolute_path(__FILE__))
    project_root = tasks_dir.gsub(/lib\/tasks/,"")

    system("ruby #{project_root}/lib/tasks/create_csv_total_payment.rb")
  end
end

