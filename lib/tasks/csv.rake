# create csv files
namespace :csv do
  task :create_total_payment do
    # gets the project root
    tasks_dir = File.dirname(File.absolute_path(__FILE__))
    project_root = tasks_dir.gsub(/lib\/tasks/,"")

    Rake::Task['csv:create_total_payment'].invoke
  end
end
