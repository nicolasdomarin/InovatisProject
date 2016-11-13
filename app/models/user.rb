class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :tasks
  has_many :conversations, :foreign_key => :sender_id

  after_create :create_default_conversation
  before_save :add_params

  def is_admin? 
    admin
  end

  
  def is_reseller?
    reseller   
  end

  private

  # for demo purposes

  def add_params
    self.reseller = true
  end


  def create_default_conversation

    Conversation.create(sender_id: 1, recipient_id: self.id) unless self.id == 1
  end
end
