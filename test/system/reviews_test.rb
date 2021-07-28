require "application_system_test_case"

class ReviewsTest < ApplicationSystemTestCase
  setup do
    @review = reviews(:one)
  end

  test "visiting the index" do
    visit reviews_url
    assert_selector "h1", text: "Reviews"
  end

  test "creating a Review" do
    visit reviews_url
    click_on "New Review"

    fill_in "Content", with: @review.content
    fill_in "Job", with: @review.job_id
    fill_in "Profile", with: @review.profile_id
    fill_in "Rating", with: @review.rating
    fill_in "Review from", with: @review.review_from
    fill_in "Review to", with: @review.review_to
    click_on "Create Review"

    assert_text "Review was successfully created"
    click_on "Back"
  end

  test "updating a Review" do
    visit reviews_url
    click_on "Edit", match: :first

    fill_in "Content", with: @review.content
    fill_in "Job", with: @review.job_id
    fill_in "Profile", with: @review.profile_id
    fill_in "Rating", with: @review.rating
    fill_in "Review from", with: @review.review_from
    fill_in "Review to", with: @review.review_to
    click_on "Update Review"

    assert_text "Review was successfully updated"
    click_on "Back"
  end

  test "destroying a Review" do
    visit reviews_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Review was successfully destroyed"
  end
end
