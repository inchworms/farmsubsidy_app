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

    # ruby check is file is present
    if File.exists?("#{project_root}/public/d3_data/payments_grouped.json")
      #if it is then drop the file
      system("rm #{project_root}/public/d3_data/payments_grouped.json")
    end

    PaymentRecipientTotal.payments_grouped
  end
end
