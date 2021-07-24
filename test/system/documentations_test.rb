require "application_system_test_case"

class DocumentationsTest < ApplicationSystemTestCase
  setup do
    @documentation = documentations(:one)
  end

  test "visiting the index" do
    visit documentations_url
    assert_selector "h1", text: "Documentations"
  end

  test "creating a Documentation" do
    visit documentations_url
    click_on "New Documentation"

    fill_in "Abn number", with: @documentation.abn_number
    check "Insured" if @documentation.insured
    fill_in "Npc reference", with: @documentation.npc_reference
    fill_in "Profile", with: @documentation.profile_id
    click_on "Create Documentation"

    assert_text "Documentation was successfully created"
    click_on "Back"
  end

  test "updating a Documentation" do
    visit documentations_url
    click_on "Edit", match: :first

    fill_in "Abn number", with: @documentation.abn_number
    check "Insured" if @documentation.insured
    fill_in "Npc reference", with: @documentation.npc_reference
    fill_in "Profile", with: @documentation.profile_id
    click_on "Update Documentation"

    assert_text "Documentation was successfully updated"
    click_on "Back"
  end

  test "destroying a Documentation" do
    visit documentations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Documentation was successfully destroyed"
  end
end
