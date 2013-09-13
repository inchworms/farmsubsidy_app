# create and migrate new database

namespace :db do
  desc 'create a new db, drop old one with same name if present'
  # TODO: is NOT droping the database
  task :create do
    if system("psql -l | grep #{DATABASE_NAME}")
      #if it is then drop the db 
      system("dropdb #{DATABASE_NAME}")
    end
    system("createdb #{DATABASE_NAME}")
  end

  desc 'migrate database'
  task :migrate do
    unless defined?(DB)
      DB = Sequel.postgres("#{DATABASE_NAME}")
    end
    Sequel::Migrator.run(DB, './db/migrations', :use_transactions=>true)
  end
end
