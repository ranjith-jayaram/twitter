class User < ApplicationRecord
  has_many :interests
  has_many :hashtags, through: :interests, foreign_key: "user_id"
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following_users, through: :active_relationships,  source: :followed, source_type: "User"
  has_many :following_microposts, through: :active_relationships,  source: :followed, source_type: "Micropost"
  has_many :following_hashtags, through: :active_relationships,  source: :followed, source_type: "Hashtag"
  has_many :followers, through: :passive_relationships, source: :follower


  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
    # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
    # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
   # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
        # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end
    # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  def feed
    following_user_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id AND followed_type = 'User'"

   # following_hashtag_ids = "SELECT followed_id FROM relationships
   #                  WHERE  follower_id = :hashtag_id AND followed_type = 'Hashtag'"
    micropost_ids ="SELECT micropost_id FROM trends WHERE hashtag_id in (SELECT followed_id FROM relationships
                    WHERE  follower_id = :user_id AND followed_type = 'Hashtag')" 
    
    Micropost.where("id IN (#{micropost_ids}) OR user_id IN (#{following_user_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
    # Follows a user.
  def follow(followed_object, followed_object_type)
    active_relationships.create(followed_id: followed_object.id, followed_type: followed_object_type)
  end

  # Unfollows a user.
  def unfollow_user(other_user)
    following_users.delete(other_user)
  end
  def unfollow_hashtag(hashtag)
    following_hashtags.delete(hashtag)
  end
  def unfollow_micropost(micropost)
    following_microposts.delete(micropost)
  end

  # Returns true if the current user is following the other user.
  def following_user?(user)
    following_users.include?(user)
  end
  def following_tag?(hashtag)
    following_hashtags.include?(hashtag)
  end
  def following_micropost?(micropost)
    following_microposts.include?(micropost)
  end

  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end