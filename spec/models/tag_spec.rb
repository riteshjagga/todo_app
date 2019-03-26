require 'rails_helper'

RSpec.describe Tag, type: :model do

  #Validation tests
  it {should validate_presence_of(:name)}

end