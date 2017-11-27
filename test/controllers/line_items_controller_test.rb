require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  setup do
    @line_item = line_items(:one)
    @product = products(:one)
    # @cart = carts(:my_cart)
    # @line_item = LineItem.create(product: @product)
    # rake db:test:prepare
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post :create, product_id: products(:ruby).id, cart_id: carts(:my_cart).id 
    end
    assert_equal session[:counter], 0

    assert_redirected_to store_path
  end

  test "should create line_item via ajax" do
    assert_difference('LineItem.count') do
      xhr :post, :create, product_id: products(:ruby).id
    end

    assert_response :success
    assert_select_jquery :html, '#cart' do
      assert_select 'tr#current_item td', /Programming Ruby 1.9/
    end
  end

  test "should not add duplicated product" do
    post :create, product_id: @product.id
    assert_difference('LineItem.count',0) do
      post :create, product_id: @product.id
    end
    assert_equal session[:counter], 0

    assert_redirected_to store_url
  end

  test "should increment quantity of duplicated product" do
    @line_item = LineItem.create(product: @product)
    # byebug
    assert_difference('@line_item.quantity') do
      post :create, product_id: @product.id
    end
    assert_equal session[:counter], 0

    assert_redirected_to store_url
  end

  test "should show line_item" do
    get :show, id: @line_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @line_item
    assert_response :success
  end

  test "should update line_item" do
    patch :update, id: @line_item, line_item: {product_id: @line_item.product_id }
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  test "should destroy line_item" do
    @line_item.cart = carts(:one)
    assert_difference('LineItem.count', -1) do
      delete :destroy, id: @line_item
    end

    # assert_redirected_to line_items_path
    assert_redirected_to cart_path(assigns(:line_item).cart)
  end
end
