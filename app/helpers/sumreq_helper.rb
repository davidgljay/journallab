module SumreqHelper
  def hide_my_sumreq(item)
   !item.sumreqs.select{|s| s.user == current_user}.empty? ?  'hideonload ':''
  end
end
