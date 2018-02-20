class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable

  has_one :proposal_setting

  after_create :create_proposal_setting

  def profile_incomplete?
  	business_name.blank? || owner_first.blank? || owner_last.blank? || address.blank? || city.blank? || state.blank? || phone.blank?
  end


  private 

    def create_proposal_setting
      ProposalSetting.create(:user_id => self.id, :return_email => self.email, :tier1_name => "BRONZE", :tier2_name => "SILVER" , :tier3_name => "GOLD")
    end

end


