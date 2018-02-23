module ApplicationHelper
	#Returns correct title for pages if it's not provided
	def full_title(page_title = '')
		base_title = "Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			base_title
		else
			page_title + ' | ' + base_title
		end
	end
end
