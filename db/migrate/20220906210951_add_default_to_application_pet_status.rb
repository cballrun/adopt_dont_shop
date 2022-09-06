class AddDefaultToApplicationPetStatus < ActiveRecord::Migration[5.2]
  def up
    change_column_default :application_pets, :status, from: nil, to: 'Pending'
    ApplicationPet.where(status: nil).update_all("status = 'Pending'")
  end

  def down
    change_column_default :application_pets, :status, from: 'Pending', to: nil
    ApplicationPet.where(status: 'Pending').update_all("status = NULL")
  end
end
