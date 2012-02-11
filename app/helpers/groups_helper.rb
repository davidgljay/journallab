require 'csv'

module GroupsHelper

#Moving these into a model until I can figure out why they don't work on heroku...

#Takes a 2D array
def export_data(array, name = "data")
   CSV.open("public/data/" + name + "_" + Time.now.strftime("%m_%d_%Y_%H:%M:%S") + ".csv", "w") do |csv|
    csv << array
  end
end

#Takes an array, returns a frequency array by day

def graph_by_day(array)
    array.sort!{|x,y| x.created_at <=> y.created_at}
    finish = array.last.created_at + 1.day
    start = array.first.created_at -1.day
    days = []
    day = start.midnight
    while day < finish.midnight
       days << day
       day += 1.day
    end
    formatted_date = days.map{|day| day.strftime("%D")}
    values = days.map{|day| array.select{|object| object.created_at > day && object.created_at < day + 1.day}.count}
    graph = [formatted_date,values]
end

end

