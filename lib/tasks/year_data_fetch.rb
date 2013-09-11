require 'rubygems'
require 'sequel'
require 'logger'

# connect to an in-memory database
DB = Sequel.postgres("farmsubsidy_performance_add_top_payments", :loggers => [Logger.new($stdout)])

# create a dataset from years
year = DB[:years]

years_array = [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013]
years_array.each do |x|
  year.insert(
    year: [x]
  )
end