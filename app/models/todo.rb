class Todo

  # Modules inclusion
  include Mongoid::Document
  include Mongoid::Enum
  include Mongoid::Timestamps

  ### declaring scopes to get results based on conditions
  scope :not_deleted, ->{ where(is_deleted: false) }
  scope :deleted, ->{ where(is_deleted: true) }

  # Collection's fields
  field :title, type: String
  enum :status, [:not_started, :started, :finished], default: :not_started
  field :is_deleted, type:Boolean, default: false

  # Validations
  validates :title, presence: true, length: {minimum: 5, maximum: 150}
  validates :status, presence: true
  validates :is_deleted, presence: true

  # Associations
  has_and_belongs_to_many :tags

end
