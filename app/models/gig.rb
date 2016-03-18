class Gig < ActiveRecord::Base
  include SharedMethods
  belongs_to :category
  belongs_to :user
  has_many :bids
  has_many :reviews
  has_many :images, as: :imageable
  enum status: %w(open closed finished paused)

  validates :name, :description, :budget, :location, presence: true
  validates :budget, numericality: true
  validates :budget, numericality: { greater_than_or_equal_to: 0 }
  validate :max_images

  before_create :set_uid

  default_scope { where(archived: false) }

  geocoded_by :location
  after_validation :geocode

  searchkick locations: [:location]
  
  SEARCH_RATE = [5, 10, 15, 25, 50]

  def set_uid
    self.uid = rand(100000..999999)
  end

  def search_data
    attributes.merge location: {lat: latitude, lon: longitude}
  end

  def self.search_all(params)
    latitude = Geocoder.search(params[:location])[0].latitude if !Geocoder.search(params[:location]).empty?
    longitude = Geocoder.search(params[:location])[0].longitude if !Geocoder.search(params[:location]).empty?
    query = params[:search].empty? ? "*" : params[:search]
    gigs = Gig.search(query, fields: [:name, :description], where: { status: 0,
                                                                     budget: params[:min].to_i..99999,
                                                                     location: {
                                                                       near: { lat: latitude, lon: longitude }, within: "25mi"
                                                                     }
                                                                   },
                                                                   order: { created_at: :desc })
  end

  def max_images
    errors.add(:base, "Maximum images per gig is 5") if self.images.count > 2
  end
end