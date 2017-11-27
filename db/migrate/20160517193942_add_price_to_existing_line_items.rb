class AddPriceToExistingLineItems < ActiveRecord::Migration
  def up
  	LineItem.all.each { |item| item.price = Product.find(item.product_id).price }
  end
end
