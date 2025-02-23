require 'rails_helper'

RSpec.describe 'the application show' do

  before :each do
    @app_1 = Application.create!(name: "Carter Ball", street_address: "123 Easy Street", city: "Atlanta", state: "GA", zip_code: 30307)
    @app_2 = Application.create!(name: "Mary Ballantyne", street_address: "888 EZ Lane", city: "Denver", state: "CO", zip_code: 12345)
    @shelter_1 = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true)
    @pet_2 = @shelter_1.pets.create!(name: 'Gilbert', age: 4, breed: 'Mutt', adoptable: true)
    @pet_app_1 = ApplicationPet.create!(application: @app_1, pet: @pet_1)
  end

  describe 'the app information section' do
    it "shows the application and all its attributes" do
      visit "/applications/#{@app_1.id}"
      within('#appInfo') do
        expect(page).to have_content(@app_1.name)
        expect(page).to have_content(@app_1.street_address)
        expect(page).to have_content(@app_1.city)
        expect(page).to have_content(@app_1.state)
        expect(page).to have_content(@app_1.zip_code)
        expect(page).to have_content(@app_1.app_status)

        expect(page).to_not have_content(@app_2.name)
      end
    end
  end

  describe 'the Add A Pet To This Application section' do
    describe 'the pet search bar' do
      it 'exists and has a form with a button to search a pet' do
        visit "/applications/#{@app_1.id}"

        within("#searchPets") do
          expect(page).to have_content('Add a Pet to this Application')
          expect(find('form')).to have_content('Search')
          expect(page).to have_button("Search Pets By Name")
          expect(page).to_not have_content(@app_1.name)
        end
      end

      it 'returns all pets with partial matches when typed into the search bar and is case insensitive' do
        shelter_1 = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
        fancy_francis = shelter_1.pets.create!(name: "Sir Francis", breed: "Sphinx", age: 6, adoptable: true)
        fran = shelter_1.pets.create!(name: "Fran", breed: "Calico", age: 3, adoptable: true)
        visit "/applications/#{@app_2.id}"
    
        within("#searchPets") do
          fill_in('Search', with: 'fran')
          click_button("Search Pets By Name")
          
          expect(current_path).to eq("/applications/#{@app_2.id}")
          expect(page).to have_content(fancy_francis.name)
          expect(page).to have_content(fran.name)
        end
      end
    end

    describe 'the Adopt this Pet button' do
      it 'does not exist if a pet has not been searched for' do
        visit "/applications/#{@app_1.id}"
        within("#searchPets") do
          expect(current_path).to eq("/applications/#{@app_1.id}")
          expect(page).to_not have_content("Adopt This Pet")
        end
      end

      it 'shows up once a pet has been searched for' do
        visit "/applications/#{@app_1.id}"
        within("#searchPets") do
          fill_in('Search', with: 'scoo')
          click_button("Search Pets By Name")
          
          expect(current_path).to eq("/applications/#{@app_1.id}")
          expect(page).to have_button("Adopt This Pet")
        end
      end

      it 'adds a pet to an application' do
        visit "/applications/#{@app_1.id}"
        within("#addPet") do
          fill_in('Search', with: 'scoo')
          click_button("Search Pets By Name")
          
          click_on "Adopt This Pet"

          expect(current_path).to eq("/applications/#{@app_1.id}")
          expect(page).to have_content('Scooby')
        end
      end
    end
  end

  describe 'submitting an application' do
    describe 'the application submission form' do
      it 'has a form with correct attributes for application submission' do
        visit "/applications/#{@app_1.id}"
        within("#submitApp") do
          expect(find('form')).to have_content("What Would Make You A Great Owner?")
          expect(find('form')).to have_field(:description)
          expect(find('form')).to have_button("Submit")
        end
      end

      it 'does not display the form if no pets are added to the application' do
        visit "/applications/#{@app_2.id}"
        within("#submitApp") do
          expect(page).to_not have_content('What Would Make You A Great Owner?')
          expect(page).to_not have_button('Submit')
        end
      end
    end
    
    describe 'the application update' do
      context 'successful applications' do
        it 'changes an applications status after submission' do
          visit "/applications/#{@app_1.id}"
          expect(page).to have_content('Status: In Progress')

          fill_in 'What Would Make You A Great Owner?', with: "this is a description"
          click_button 'Submit'
          
          expect(current_path).to eq("/applications/#{@app_1.id}")
          expect(page).to have_content('Status: Pending')
        end

        it 'flashes a success message with successful application' do
          visit "/applications/#{@app_1.id}"
          expect(page).to_not have_content("YOU DID IT!")

          fill_in 'What Would Make You A Great Owner?', with: "this is a description"
          click_button 'Submit'
          
          expect(current_path).to eq("/applications/#{@app_1.id}")
          expect(page).to have_content("YOU DID IT!")
        end

        it 'no longer has search or submit functions after submission' do
          visit "/applications/#{@app_1.id}"
          expect(page).to have_content('Search pet')
          expect(page).to have_content('What Would Make You A Great Owner?')

          fill_in 'What Would Make You A Great Owner?', with: "this is a description"
          click_button 'Submit'

          expect(page).to_not have_content('Search pet')
          expect(page).to_not have_content('What Would Make You A Great Owner?')
        end
      end
    
      context 'unsuccessful applications' do
        it 'flashes an error message if user does not input a description' do
          visit "/applications/#{@app_1.id}"
          expect(page).to_not have_content("Please fill in the What Would Make You A Great Owner section")
          
          fill_in 'What Would Make You A Great Owner?', with: '' 
          click_button 'Submit'
          
          expect(current_path).to eq("/applications/#{@app_1.id}")
          expect(page).to have_content("Please fill in the What Would Make You A Great Owner section")
        end
        
        it 'still has search and submit functions after unsuccessful submission' do
          visit "/applications/#{@app_1.id}"
          expect(page).to have_content('Search pet')
          expect(page).to have_content('What Would Make You A Great Owner?')
          
          fill_in 'What Would Make You A Great Owner?', with: '' 
          click_button 'Submit'

          expect(page).to have_content('Search pet')
          expect(page).to have_content('What Would Make You A Great Owner?')
        end
      
        it 'does not change the applications status' do
          visit "/applications/#{@app_1.id}"
          expect(page).to have_content('Status: In Progress')
        
          fill_in 'What Would Make You A Great Owner?', with: '' 
          click_button 'Submit'
        
          expect(page).to have_content('Status: In Progress')
        end
      end
    end
  end
end

