class RankingsController < ApplicationController
  
  def want
    #binding.pry
    #want_ids = Ownership.where(type:"Want")
    want_ids = Want.group(:item_id)
                    .order('count_item_id desc')
                    .limit(10)
                    .count('item_id')
                    .keys
    #検索して多い順に並び替え
    @items = Item.find(want_ids).sort_by{|o| want_ids.index(o.id)}
  end
  
  def have
    #binding.pry
    #have_ids = Ownership.where(type:"Have")
    have_ids = Have.group(:item_id)
                    .order('count_item_id desc')
                    .limit(10)
                    .count('item_id')
                    .keys
    #検索して多い順に並び替え
    @items = Item.find(have_ids).sort_by{|o| have_ids.index(o.id)}
  end
  
end
