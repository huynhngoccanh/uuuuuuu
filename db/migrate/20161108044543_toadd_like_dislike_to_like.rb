class ToaddLikeDislikeToLike < ActiveRecord::Migration
  def change
  	add_column 	:likes 	,:like 		,:boolean
  	add_column	:likes 	,:dislike 	,:boolean

  end
end
