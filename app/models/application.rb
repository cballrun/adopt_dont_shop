class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets

  validates_presence_of :name, :street_address, :city, :state, :zip_code, :description

  def status
    return 'Pending' if description.present?

    'In Progress'
  end
end
