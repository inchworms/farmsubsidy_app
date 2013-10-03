# create json files
namespace :json do
  desc "create a json file with grouped payments for treemap"
  task :create_json_with_grouped_payments do
    # connect to an postgres database
    unless defined?(DB)
      DB = Sequel.postgres("#{DATABASE_NAME}", :loggers => LOGGERS) 
    end

    tasks_dir = File.dirname(File.absolute_path(__FILE__))
    project_root = tasks_dir.gsub(/lib\/tasks/,"")
    Dir.glob(project_root + "/models/*.rb").each{|f| require f}

    # if system("psql -l | grep #{DATABASE_NAME}")
    #   #if it is then drop the db 
    #   system("dropdb #{DATABASE_NAME}")
    # end

    PaymentRecipientTotal.payments_grouped
  end
end
