class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable
  has_one :proposal_setting
  #Once a user has signed up, we create their proposal setting with default values
  #That they can then edit
  after_create :create_proposal_setting
  #Make sure user has an email
  validates :email, presence: true
  #Make sure an email can be used only once
  validates_uniqueness_of :email
  
  #Method that returns if the profile is incomplete
  def profile_incomplete?
  	business_name.blank? || owner_first.blank? || owner_last.blank? || address.blank? || city.blank? || state.blank? || phone.blank?
  end


  private 
    #After a User is created, We create their blank Proposal Settings with pre-populated options they can then change
    def create_proposal_setting
      ProposalSetting.create(:user_id => self.id, :return_email => self.email, :tier1_name => "BRONZE", :tier2_name => "SILVER" , :tier3_name => "GOLD")
    end

end


