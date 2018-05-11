class Hashtag < ApplicationRecord
	has_many :relationships, foreign_key: "followed_id"
	has_many :followers, through: :relationships, source: :follower
	has_many :trends
	has_many :microposts, through: :trends, foreign_key: "hashtag_id"
	default_scope -> { order(created_at: :desc) }
	validates :content, presence: true, length: { maximum: 20 } 
end
