require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  describe "relationships" do
    it {should belong_to :application}
    it {should belong_to :pet}
  end
  
  describe 'default attributes' do
    it 'initializes with the correct default status' do
      app_1 = Application.create!(name: "Carter Ball", street_address: "123 Easy Street", city: "Atlanta", state: "GA", zip_code: 30307, status: "In Progress", description: "something")
      shelter_1 = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
      pet_1 = shelter_1.pets.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true)
      pet_app_1 = ApplicationPet.create!(application: app_1, pet: pet_1)

      expect(pet_app_1.status).to eq("Pending")
    end
  end

  
end
