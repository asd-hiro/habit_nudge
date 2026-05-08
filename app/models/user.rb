class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }
  validates :character_name, presence: true, length: { maximum: 50 }

  has_one :character, dependent: :destroy
  has_many :routines, dependent: :destroy

  after_create :create_default_character

  private

  def create_default_character
    # character_name カラムの値を使用してキャラクターを作成
    create_character!(
      level: 1,
      exp: 0,
      condition: 0
    )
  end
end
