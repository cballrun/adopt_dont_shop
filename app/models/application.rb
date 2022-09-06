class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets
  attribute :status, default: "In Progress"
  validates_presence_of :name, :street_address, :city, :state, :zip_code

  # TODO: make this a class (self) method and remove Pet.all so it can be chained
  def search_pet(name)
    Pet.all.where("name ILIKE ?", "%#{name}%")
  end
end
