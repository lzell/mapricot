# Coming soon!
# class NaturalInputs < Mapricot
#   has_one   :message, :string
#   has_many  :occurrences, :xml
# end
#
#
# class Occurrence < Mapricot::Base
#   has_one   :start_date
#   has_one   :end_date
#   has_one   :interval
#   has_one   :day_of_week
#   has_one   :week_of_month
#   has_one   :start_time
#   has_one   :end_time
#   has_one   :date_of_month
# end
# 
# 
# n = NaturalInputs.new("http://localhost:3000/query?q=lunch+this+friday+with+maria")
# puts n.message # => "lunch with maria"
# puts n.occurrences.first.start_date # => "2009-01-16"
