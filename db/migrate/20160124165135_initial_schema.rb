class InitialSchema < ActiveRecord::Migration
  
  def change
    create_table(:gigs) do |t|
      t.string  :name, null: false
      t.text    :description, null: false
      t.decimal :budget, null: false
      t.integer :status, default: 0, null: false
      t.integer :awarded_bid
      t.string  :location, null: false
      t.float   :latitude
      t.float   :longitude
      t.integer :uid, index: { unique: true}, null: false
      t.boolean :archived, default: false
      t.timestamps
    end

    create_table(:categories) do |t|
      t.string :name
    end

    create_table(:bids) do |t|
      t.decimal :amount, null: false
      t.text    :description, null: false
      t.boolean :archived, default: false
      t.timestamps
    end

    create_table(:reviews) do |t|
      t.text    :comment, null: false
      t.integer :rating, null: false
      t.integer :reviewer, null: false
      t.timestamps
    end

    create_table(:conversations) do |t|
     t.integer  :sender_id
     t.integer  :recipient_id
     t.datetime :updated_at
     t.boolean  :archived, default: false
     t.timestamps
    end

    create_table(:messages) do |t|
      t.text    :subject
      t.text    :body, null: false
      t.timestamps
    end

    create_table(:images) do |t|
      t.string :image_uid
      t.string :image_name
      t.string :imageable_id
      t.string :imageable_type
      t.timestamps
    end

    add_reference :gigs,      :category,      index: true
    add_reference :gigs,      :user,          index: true
    add_reference :bids,      :gig,           index: true
    add_reference :bids,      :user,          index: true
    add_reference :reviews,   :user,          index: true
    add_reference :reviews,   :gig,           index: true
    add_reference :messages,  :user,          index: true
    add_reference :messages,  :conversation,  index: true
  end
end