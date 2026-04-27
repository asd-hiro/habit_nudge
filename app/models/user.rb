class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :character_name, presence: true

  has_one :character, dependent: :destroy
  has_many :routines, dependent: :destroy

  after_create :create_default_character

  private

  def create_default_character
    # character_name カラムの値を使用してキャラクターを作成
    create_character!(
      name: character_name,
      level: 1,
      exp: 0,
      condition: 0
    )
  end
end
