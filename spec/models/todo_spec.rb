require 'rails_helper'

RSpec.describe Todo, type: :model do

  #Validation tests
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:status)}
  it {should validate_presence_of(:is_deleted)}

end