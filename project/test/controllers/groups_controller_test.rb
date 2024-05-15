require "test_helper"

class GroupsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers

  test "should get index" do
    sign_in users(:esteban12)
    get groups_url
    assert_response :success
    assert_select 'h2', 'Todos los grupos'
  end

  test "should get show" do
    sign_in users(:esteban12)
    # get group_url(groups(:animalesaaa))
    get group_url(groups(:animalesaaa)), params: { id: groups(:animalesaaa).id }
    # Assertion for checking show.html.erb view
    assert_response :success
    assert_select 'h1', groups(:animalesaaa).name
  end

  test "should get show with admin options" do
    sign_in users(:esteban11)
    # get group_url(groups(:animalesaaa))
    get group_url(groups(:animalesaaa)), params: { id: groups(:animalesaaa).id }
    # Assertion for checking show.html.erb view
    assert_response :success
    assert_select 'h2', 'Opciones de administrador de grupo', "The page should have admin options"
  end


  test "should get show without admin options" do
    sign_in users(:esteban12)
    # get group_url(groups(:animalesaaa))
    get group_url(groups(:animalesaaa)), params: { id: groups(:animalesaaa).id }
    # Assertion for checking show.html.erb view
    assert_response :success

    # From https://github.com/rails/rails-dom-testing/blob/main/lib/rails/dom/testing/assertions/selector_assertions.rb
    assert_select "h2", {count: 0, text: "Opciones de administrador de grupo"}, "Should not have admin options"
  end

  # test "should get new" do
  #   sign_in users(:esteban12)
  #   get groups_new_url
  #   assert_response :success
  # end

  # test "should get edit" do
  #   sign_in users(:esteban12)
  #   get groups_edit_url
  #   assert_response :success
  # end
end
