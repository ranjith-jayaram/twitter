module MicropostsHelper
	def display_micropost(micropost) 
		content = micropost.content
		hash_tags = content.scan(/#(\w+)/)
		hash_tags.flatten.uniq.each do |hash_tag|
	    	hash_link = link_to(hash_tag, root_url)
	    	content.gsub!(hash_tag, hash_link)
		end
		content.html_safe
	end
end
