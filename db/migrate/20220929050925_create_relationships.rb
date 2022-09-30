class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id  #フォローしたユーザーのid
      t.integer :followed_id  #フォローされたユーザーid

      t.timestamps
    end
  end
end
