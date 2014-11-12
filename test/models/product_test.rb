require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products

  test "product attributes must not be empty" do
    product = Product.new 
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must not be empty" do
  	product = Product.new(	title: "sdlkfgdfgjklhk",
  							description: "sskdjfsdf",
  							image_url: "dfkj.jpg")
  	product.price  = -1
  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

  	product.price  = 0
  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

  	product.price  = 1 
  	assert product.valid?
  end

	def new_product(image_url)
		Product.new(title: "sdflkjahsgdy",
								description: "description",
								price: 39.00,
								image_url: image_url)
	end

  test "image url" do
  	ok = %w{fred.jpg fred.gif fred.png FRED.JPG FRED.GIF http://a/b/c/fred.gif}
  	bad = %w{fred.doc fred.gif/more fred.gif.more }

  	ok.each do |name|
  		assert new_product(name).valid?, "#{name} should be valid"  
  	end

  	bad.each do |name|
  		assert new_product(name).invalid?, "#{name} should be invalid"  
  	end
  end

  test "product title must not be unique" do
  	product = Product.new(	title: products(:ruby).title,
  							description: "sskdjfsdf",
  							image_url: "dfkj.jpg")

  	assert product.invalid?
  	assert_equal ["has already been taken"], product.errors[:title]
  end
end
