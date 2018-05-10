class Trend < ApplicationRecord
	belongs_to :hashtag
	belongs_to :micropost
end
