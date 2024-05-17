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

  # tests related to my_groups
  test "should get my groups" do
    sign_in users(:esteban12)
    get groups_mine_url
    assert_response :success
    assert_select 'h2', 'Grupos creados por mí'
    assert_select 'h2', 'Grupos a los que pertenezco'
  end
  test "should show the groups i created" do
    sign_in users(:esteban11)
    get groups_mine_url
    assert_response :success
    assert_select 'h2', 'Grupos creados por mí'
    assert_select 'h2', 'Grupos a los que pertenezco'
    assert_select 'h5', 'Grupo Animalesaaa'
  end
  test "should show the groups i belong to" do
    sign_in users(:esteban11)
    get groups_mine_url
    assert_response :success
    assert_select 'h2', 'Grupos creados por mí'
    assert_select 'h2', 'Grupos a los que pertenezco'
    assert_select 'h5', 'Grupo Otakusaaa'
  end

  # tests related to edit
  test "should get the edit page for a group that i created" do
    sign_in users(:esteban11)
    get edit_group_url(groups(:animalesaaa))
    assert_response :success
    assert_select 'h2', 'Editar grupo'
  end

  test "should not get the edit page for a group that i did not create" do
    sign_in users(:esteban11)
    get edit_group_url(groups(:otakusaaa))
    assert_response :forbidden
  end


  # tests related to index
  test "should get the index page for groups" do
    sign_in users(:esteban11)
    get groups_url
    assert_response :success
  end

  test "should get the index page for groups and show a group name that exists" do
    sign_in users(:esteban11)
    get groups_url
    assert_response :success
    assert_select 'h5', 'Grupo Otakusaaa'
  end


end
