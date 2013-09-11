namespace :db do 
  task :migrate do
    require "sequel"
    Sequel.extension :migration
    DB = Sequel.postgres("farmsubsidy_development")
    Sequel::Migrator.run(DB, './db/migrations', :use_transactions=>true)
  end

  task :set_up_performance_test_db do
    require "sequel"
    Sequel.extension :migration

    #check to see if performance DB already exists
    the_database_is_there = system("psql -l | grep farmsubsidy_performance")
    if the_database_is_there
      #if it does then drop the db 
      system("dropdb farmsubsidy_performance")
    end
    #and recreate it
    system("createdb farmsubsidy_performance")

    DB = Sequel.postgres("farmsubsidy_performance")
    Sequel::Migrator.run(DB, './db/migrations', :use_transactions=>true)
  end

  task :run_any_new_migration do
    require "sequel"
    Sequel.extension :migration

    DB = Sequel.postgres("farmsubsidy_performance_add_top_payments")
    Sequel::Migrator.run(DB, './db/migrations', :use_transactions=>true)
  end

end



namespace :example do
  desc "I am task one"
  task :task_1 do
     p "Hello"
  end

  desc "I am task two"
  task task_2: :task_1 do
     p "and goodbye"
  end

  desc "I am task three"
  task task_ubun3: [:task_2, :task_1] do
     p "and goodbye 3"
  end
end