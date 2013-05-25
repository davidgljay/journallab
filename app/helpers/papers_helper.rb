module PapersHelper

def authorname(a)
		a[:lastname] + ", " + a[:firstname]
end

def safeuser(user)
  if user.nil?
    User.new
  else
    user
  end
end

end


