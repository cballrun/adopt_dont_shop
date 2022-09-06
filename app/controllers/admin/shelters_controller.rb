module Admin
  class SheltersController < ApplicationController
    def index
      @shelters = Shelter.find_by_sql("SELECT * FROM Shelters ORDER BY Name DESC")
      @pending_shelters_filtered = Shelter.filter_by_pending_applications
    end
  end
end
