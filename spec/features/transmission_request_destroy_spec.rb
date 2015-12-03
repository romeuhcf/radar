require 'rails_helper'

feature "Transmission request delete" , :js do
  let(:user){create(:confirmed_user)}

  scenario 'while just starting composing' do
    compose_transmission_request_until_step
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept
  end

  scenario "while uploaded" do
    compose_transmission_request_until_step 'upload'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept
  end

  scenario "while defined parse" do
    compose_transmission_request_until_step 'parse'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept
  end

  scenario "while defined message" do
    compose_transmission_request_until_step 'message'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept
  end

  scenario "while schedule message" do
    compose_transmission_request_until_step 'schedule'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept
  end

  scenario "while scheduled" do
    compose_transmission_request_until_step 'confirm'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept

  end
  scenario "while processing"
  scenario "while paused"
  scenario "while cancelled"
end
