class User < ApplicationRecord
  has_many :wikis, dependent: :destroy
  has_many :collaborators, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save { self.email = email.downcase if email.present? }
  after_initialize :initialize_role

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true
  validates :password, length: { minimum: 6 }, unless: "password.nil?"
  validates :password, presence: true, if: "id.nil?"
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 1, maximum: 254 }

  def initialize_role
    self.role ||= :standard
  end

  enum role: [:standard, :premium, :admin]
end
