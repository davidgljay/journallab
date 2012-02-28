module PagesHelper

def make_ratio_graph(array1, array2)
  days = dayrange([array1[0][0] + 1.day, array2[0][0] + 1.day].min,[array1[0][-1], array2[0][-1]].max)
  ratio = [days,[]]
  days.each do |day|
   # Need to look into getting the index of the first array to access the second array 
    x = array1[0].map{|a| a.midnight}.include?(day) ? array1[1][array1[0].index(day)] : 0
    y = array2[0].map{|a| a.midnight}.include?(day) ? array2[1][array2[0].index(day)] : 0
    float = y == 0 ? 0 : (x.to_f/y.to_f)
    ratio[1] << [float]
  end
  ratio
end

#Accepts two arrays of integers and spits back a float ratio

def make_ratio(array1, array2)
   array1.inject(0){|sum, item| sum + item}.to_f/array2.inject(0){|sum, item| sum + item}.to_f
end


end
