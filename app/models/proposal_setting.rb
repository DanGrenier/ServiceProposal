class ProposalSetting < ActiveRecord::Base

  #t.integer "user_id"
  #t.string  "return_email"
  #t.string  "tier1_name"
  #t.string  "tier2_name"
  #t.string  "tier3_name"
  #t.string  "proposal_default_text"

  belongs_to :user

  validates :return_email, :format => {:with => /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i , :message => 'must be a valid email'}
  validates_presence_of :user_id
  validates_presence_of :return_email, :message => "Please enter the return email address"
  validates_presence_of :tier1_name, :message => "Please enter the Tier1 name"
  validates_presence_of :tier2_name, :message => "Please enter the Tier2 name"
  validates_presence_of :tier3_name, :message => "Please enter the Tier3 name"

  
  def self.get_proposal_settings(user_id)
  	self.find_by(user_id: user_id)
  end

 
end