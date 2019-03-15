class Tag

  # Modules inclusion
  include Mongoid::Document
  include Mongoid::Timestamps

  # Collection's fields
  field :name, type: String

  # Validations
  validates :name, presence: true, uniqueness: true, length: {minimum: 3, maximum: 25}

  # Associations
  has_and_belongs_to_many :todos

end
