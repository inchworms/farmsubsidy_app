# create and migrate new database

namespace :db do 
  desc 'create a new db, drop old one with same name if present'
  task :create do
    if system("psql -l | grep #{@database_name}")
      #if it is then drop the db 
      system("dropdb #{@database_name}")
    end
    system("createdb #{@database_name}")
  end
  
  desc 'migrate database'
  task :migrate do
    DB = Sequel.postgres("#{@database_name}")
    Sequel::Migrator.run(DB, './db/migrations', :use_transactions=>true)
  end
end