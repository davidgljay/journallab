require 'fastercsv'

module GroupsHelper

#Takes a 2D array
def export_data(array, name = "data")
  FasterCSV.open("/public/data/" + name + "_" + Time.now.strftime("%m_%d_%Y_%H:%M:%S") + ".csv", "w") do |csv|

    csv << array
  end
end

#Takes an array, returns a frequency array by day

def graph_by_day(array)
    array.sort!{|x,y| x.created_at <=> y.created_at}
    days = dayrange(array.first.created_at + 1.day, array.last.created_at)
    formatted_date = days.map{|day| day.strftime("%D")}
    values = days.map{|day| array.select{|object| object.created_at > day && object.created_at < day + 1.day}.count}
    graph = [days,values]
end

def dayrange(start, finish)
    days = []
    day = start.midnight
    while day < finish.midnight
       days << day
       day += 1.day
    end
    days
end

end
