require "application_system_test_case"

class PropertiesTest < ApplicationSystemTestCase
  setup do
    @property = properties(:one)
  end

  test "visiting the index" do
    visit properties_url
    assert_selector "h1", text: "Properties"
  end

  test "creating a Property" do
    visit properties_url
    click_on "New Property"

    fill_in "Bath", with: @property.bath
    fill_in "Bed", with: @property.bed
    fill_in "Description", with: @property.description
    fill_in "Profile", with: @property.profile_id
    fill_in "Storey", with: @property.storey
    fill_in "Street address", with: @property.street_address
    fill_in "Suburb", with: @property.suburb_id
    fill_in "Type", with: @property.property_type
    click_on "Create Property"

    assert_text "Property was successfully created"
    click_on "Back"
  end

  test "updating a Property" do
    visit properties_url
    click_on "Edit", match: :first

    fill_in "Bath", with: @property.bath
    fill_in "Bed", with: @property.bed
    fill_in "Description", with: @property.description
    fill_in "Profile", with: @property.profile_id
    fill_in "Storey", with: @property.storey
    fill_in "Street address", with: @property.street_address
    fill_in "Suburb", with: @property.suburb_id
    fill_in "Type", with: @property.property_type
    click_on "Update Property"

    assert_text "Property was successfully updated"
    click_on "Back"
  end

  test "destroying a Property" do
    visit properties_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Property was successfully destroyed"
  end
end
