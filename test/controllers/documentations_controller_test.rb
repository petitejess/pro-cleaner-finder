require "test_helper"

class DocumentationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @documentation = documentations(:one)
  end

  test "should get index" do
    get documentations_url
    assert_response :success
  end

  test "should get new" do
    get new_documentation_url
    assert_response :success
  end

  test "should create documentation" do
    assert_difference('Documentation.count') do
      post documentations_url, params: { documentation: { abn_number: @documentation.abn_number, insured: @documentation.insured, npc_reference: @documentation.npc_reference, profile_id: @documentation.profile_id } }
    end

    assert_redirected_to documentation_url(Documentation.last)
  end

  test "should show documentation" do
    get documentation_url(@documentation)
    assert_response :success
  end

  test "should get edit" do
    get edit_documentation_url(@documentation)
    assert_response :success
  end

  test "should update documentation" do
    patch documentation_url(@documentation), params: { documentation: { abn_number: @documentation.abn_number, insured: @documentation.insured, npc_reference: @documentation.npc_reference, profile_id: @documentation.profile_id } }
    assert_redirected_to documentation_url(@documentation)
  end

  test "should destroy documentation" do
    assert_difference('Documentation.count', -1) do
      delete documentation_url(@documentation)
    end

    assert_redirected_to documentations_url
  end
end
