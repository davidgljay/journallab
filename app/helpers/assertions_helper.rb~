module AssertionsHelper

def new_or_edit(assertion)
	a = new_if_nil(assertion)
	a.user == current_user ? a : Assertion.new
end

def new_if_nil(assertion)
	a = assertion.nil? ? Assertion.new : assertion
end

end
