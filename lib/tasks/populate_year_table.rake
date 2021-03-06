namespace :populate do
  desc "populate year table"
  task :year_table do

    # connect to an in-memory database
    unless defined?(DB)
      DB = Sequel.postgres("#{DATABASE_NAME}", :loggers => LOGGERS)
    end

    beginning = Time.now

    # create a dataset from years
    year = DB[:years]

    puts "\n\nNow populating the years table."

    years_array = [2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012]
    years_array.each do |x|
      year.insert(
        year: [x]
      )
    end

    puts "\nFor populating the years table the Computer needs #{Time.now - beginning} seconds."
  end
end
