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
    assert_select 'h4', groups(:animalesaaa).name
  end

  test "should get show with admin options" do
    sign_in users(:esteban11)
    # get group_url(groups(:animalesaaa))
    get group_url(groups(:animalesaaa)), params: { id: groups(:animalesaaa).id }
    # Assertion for checking show.html.erb view
    assert_response :success
    # assert_select 'h2', 'Opciones de administrador de grupo', "The page should have admin options"
    assert_select 'button', 'Editar grupo', 'Should have edit group button'
  end


  test "should get show without admin options" do
    sign_in users(:esteban12)
    # get group_url(groups(:animalesaaa))
    get group_url(groups(:animalesaaa)), params: { id: groups(:animalesaaa).id }
    # Assertion for checking show.html.erb view
    assert_response :success

    # From https://github.com/rails/rails-dom-testing/blob/main/lib/rails/dom/testing/assertions/selector_assertions.rb
    # assert_select "h2", {count: 0, text: "Opciones de administrador de grupo"}, "Should not have admin options"
    assert_select "button", {count: 0, text: "Editar grupo"}, "Should have edit group button"
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

  # tests related to edit
  test "should update group for a group that i created" do
    sign_in users(:esteban11)
    group = groups(:animalesaaa)

    patch group_url(group), params: { group: { name: "updatedname" } }

    assert_redirected_to group_path(group)
    # Reload association to fetch updated data and assert that title is updated.
    group.reload
    assert_equal "updatedname", group.name
  end

  test "should not update group for a group that i did not create" do
    sign_in users(:esteban12)
    group = groups(:animalesaaa)

    patch group_url(group), params: { group: { name: "updatedname" } }
    assert_response :forbidden
  end

  test "should not update group with invalid parameters" do
    sign_in users(:esteban11)
    group = groups(:animalesaaa)

    patch group_url(group), params: { group: { rating: "string rating" } }

    assert_response :unprocessable_entity
    # group.reload
    # puts group.rating
  end

  ## tests related to chat


  # tests related to show_chat
  test "should get the show_chat page for a group that i belong to" do
    sign_in users(:esteban11)
    get group_chat_url(groups(:animalesaaa))
    assert_response :success
    assert_select 'h2', "Mensajes del grupo #{groups(:animalesaaa).name}"
  end

  test "should not get the show_chat page for a group that i do not belong to" do
    sign_in users(:user_that_has_no_groups)
    get group_chat_url(groups(:otakusaaa))
    assert_response :forbidden
  end

  # tests related to show_chat_json
  test "should get the show_chat_json page for a group that i belong to" do
    sign_in users(:esteban11)
    get group_messages_json_url(groups(:animalesaaa))
    assert_response :success
  end
  # test de los mensajes que se muestran
  test "should show the json of a message belonging to a group" do
    sign_in users(:esteban11)
    group = groups(:animalesaaa)
    message = messages(:msg_one)
    get group_messages_json_url(group)
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal message.content, json_response[0]["content"]
  end

  test "should not get the show_chat_json page for a group that i do not belong to" do
    sign_in users(:user_that_has_no_groups)
    get group_messages_json_url(groups(:otakusaaa))
    assert_response :forbidden
  end
end
