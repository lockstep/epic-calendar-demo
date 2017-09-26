# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.find_for_google_oauth2(auth)
    user =
      User.where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
        u.provider = auth.provider
        u.uid = auth.uid
        u.email = auth.info.email
        u.password = Devise.friendly_token[0, 20]
      end
    user.token = auth.credentials.token
    user.refresh_token = auth.credentials.refresh_token
    user.save
    user
  end
end
