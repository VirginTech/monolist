class User < ActiveRecord::Base
  
  #==================
  #バリデーション
  #==================
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  #==================
  #フォロー／フォロワー
  #==================
  has_many :following_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :followed_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followed_users, through: :followed_relationships, source: :follower

  has_many :ownerships , foreign_key: "user_id", dependent: :destroy
  has_many :items ,through: :ownerships
  
  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following_users.include?(other_user)
  end

  #====================
  # Wantしているアイテムの一覧を取得するメソッド
  #====================
  has_many :want_to_items, class_name: "Want", foreign_key: "user_id", dependent: :destroy
  has_many :want_items , through: :want_to_items, source: :item

  # アイテムをWantする
  def want(item)
    #重複時エラーになる
    #want_to_items.create(item_id: item.id)
    #存在しなかった場合のみ追加
    want_to_items.find_or_create_by(item_id: item.id)
  end
  # Wantを解除する
  def unwant(item)
    want_to_items.find_by(item_id: item.id).destroy
  end
  # Wantしてるかどうか？
  def want?(item)
    want_items.include?(item)
  end

  #====================
  # Haveしているアイテムの一覧を取得するメソッド
  #====================
  has_many :have_to_items, class_name: "Have", foreign_key: "user_id", dependent: :destroy
  has_many :have_items , through: :have_to_items, source: :item

  # アイテムをHaveする
  def have(item)
    #重複時エラーになる
    #have_to_items.create(item_id: item.id)
    #存在しなかった場合のみ追加
    have_to_items.find_or_create_by(item_id: item.id)
  end
  # Haveを解除する
  def unhave(item)
    have_to_items.find_by(item_id: item.id).destroy
  end
  # Haveしてるかどうか？
  def have?(item)
    have_items.include?(item)
  end
  
end
