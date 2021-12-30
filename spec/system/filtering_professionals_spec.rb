# frozen_string_literal: true

require 'rails_helper'

describe 'Filtering professionals' do
  context 'by occupation area:' do
    it 'successfully' do
      user = User.create!(email: 'otavio@user.com.br', password: '123456789')
      @professional1 = Professional.create!(email: 'otavio@gmail.com', password: 'ahudufgvya')
      @professional2 = Professional.create!(email: 'lucas@gmail.com', password: 'ahfbfsdj')
      @occupation_area1 = OccupationArea.create!(name: 'Dev')
      @occupation_area2 = OccupationArea.create!(name: 'Designer')
      @profile1 = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins',
                                  social_name: 'Otávio Augusto', prior_experience: 'Nenhuma',
                                  educational_background: 'Matemático', occupation_area: @occupation_area1,
                                  description: 'Profissional em mud...', professional: @professional1)
      @profile2 = Profile.create!(birth_date: 23.years.ago, full_name: 'Lucas Amâncio',
                                  social_name: 'Lucas', prior_experience: 'Trabalhei na...',
                                  educational_background: 'Faculdade de...', occupation_area: @occupation_area2,
                                  description: 'Profissional soc...', professional: @professional2)

      login_as user, scope: :user
      visit root_path
      click_on 'Dev'

      expect(page).to have_link('Otávio Augusto')
      expect(page).not_to have_link('Lucas')
    end
  end
end
