class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :nickname, presence: true

  has_one :character, dependent: :destroy
  has_many :routines, dependent: :destroy

  after_create :create_default_character

  private

  def create_default_character
    # ユーザーが入力したnicknameをキャラクター名に設定
    create_character(name: nickname, level: 1, exp: 0, status: 0)
  end
end
