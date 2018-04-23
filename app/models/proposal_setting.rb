class ProposalSetting < ActiveRecord::Base

  #t.integer "user_id"
  #t.string  "return_email"
  #t.string  "tier1_name"
  #t.string  "tier2_name"
  #t.string  "tier3_name"
  #t.string  "proposal_default_text"

  belongs_to :user
  
  validates_presence_of :user_id
  validates_presence_of :return_email, :message => "Please Enter a Return Email Address"
  validates :return_email, :format => {:with => /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i , :allow_blank => true,:message => 'Please Enter a Valid Email Address'}
  validates_presence_of :tier1_name, :message => "Please Enter a Description for your Tier1"
  validates_presence_of :tier2_name, :message => "Please Enter a Description for your Tier2"
  validates_presence_of :tier3_name, :message => "Please Enter a Description for your Tier3"

  #Method that returns settings for a specific user
  def self.get_proposal_settings(user_id)
    self.find_by(user_id: user_id)
  end
 
end