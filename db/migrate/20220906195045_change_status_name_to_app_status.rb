class ChangeStatusNameToAppStatus < ActiveRecord::Migration[5.2]
  def change
    rename_column :applications, :status, :app_status
  end
end
