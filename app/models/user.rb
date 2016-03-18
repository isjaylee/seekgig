class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :gigs
  has_many :bids
  has_many :reviews
  has_many :messages

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: {minimum: 3, maximum: 20}
  validate :validate_username

  default_scope { where(archived: false) }
  before_create :set_uid

  geocoded_by :location
  after_validation :geocode

  searchkick rating: [:rating], locations: [:location]

  attr_accessor :login

  def set_uid
    self.uid = rand(100000000..999999990)
  end

  def search_data
    {
      firstname: firstname,
      lastname: lastname,
      rating: self.avg_rating.to_i,
      searchable: searchable,
    }.merge(location: {lat: latitude, lon: longitude})
  end

  def fullname
    [firstname, lastname].join(" ")
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def self.search_all(params)
    latitude = Geocoder.search(params[:location])[0].latitude if !Geocoder.search(params[:location]).empty?
    longitude = Geocoder.search(params[:location])[0].longitude if !Geocoder.search(params[:location]).empty?
    query = params[:search].nil? || params[:search].empty? ? "*" : params[:search]
    users = User.search(query, where: { location: { near: { lat: latitude, lon: longitude }, within: "25mi" },
                                        rating: { gte: params[:rating].to_i },
                                        searchable: true
                                      })
  end

  def avg_rating
    self.reviews.average(:rating).round(1) if self.reviews.present?
  end

  def conversation_count
    Conversation.where("sender_id = ? OR recipient_id = ?", self.id, self.id).count
  end
end
