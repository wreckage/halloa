class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, presence: true, 
    length: { maximum: 50 },
    uniqueness: { case_sensitive: false }
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, 
    class_name: "Relationship",
    foreign_key: "follower_id",
    dependent: :destroy
  has_many :passive_relationships, 
    class_name: "Relationship",
    foreign_key: "followed_id",
    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  before_save :generate_gravatar_id


  # Follows a user
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user
  def following?(other_user)
    following.include?(other_user)
  end

  def following_count
    following.count
  end

  def followers_count
    followers.count
  end

  def microposts_count
    microposts.count
  end

  private

    def generate_gravatar_id
      self.gravatar_id = Digest::MD5::hexdigest(email.downcase)
    end
end
