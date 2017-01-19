class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, presence: true, 
    length: { maximum: 50 },
    uniqueness: { case_sensitive: false }
  has_many :microposts, dependent: :destroy
  before_save :generate_gravatar_id


  private

    def generate_gravatar_id
      self.gravatar_id = Digest::MD5::hexdigest(email.downcase)
    end
end
