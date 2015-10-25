class Item < ActiveRecord::Base
  serialize :raw_info , Hash

  has_many :ownerships  , foreign_key: "item_id" , dependent: :destroy
  has_many :users , through: :ownerships
  
  #====================
  # Wantしているユーザーの一覧を取得するメソッド
  #====================
  has_many :want_to_users, class_name: "Want", foreign_key: "item_id", dependent: :destroy
  has_many :want_users , through: :want_to_users, source: :user
  
  #====================
  # Haveしているユーザーの一覧を取得するメソッド
  #====================
  has_many :have_to_users, class_name: "Have", foreign_key: "item_id", dependent: :destroy
  has_many :have_users , through: :have_to_users, source: :user

end
