class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable

  def profile_incomplete?
  	business_name.blank? || owner_first.blank? || owner_last.blank? || address.blank? || city.blank? || state.blank? || phone.blank?
  end
end


