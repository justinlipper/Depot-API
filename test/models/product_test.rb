

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new

    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:images_url].any?
  end #End of test if empty

  test "product price must be positive" do
    product = Product.new(title: "My Book Title", description: "yyy", image_url: "zzz.jpg")

    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')

    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than of equal to 0.01", product.errors[:price].join('; ')

    product.price = 1
    assert product.invalid? 
  end #End of test positive 

  def new_product(image_url)
    Product.new(title: "My Book Title", description: "yyy", proce: 1, image_url: image_url)
  end #End of new_product function

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.jpg
            http://a.b.c/x/y/z/fred.gif}
    bad = %w{ fred.doc fred.gif/more fred.gif.more}

    ok.eash do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end#End of if ok test

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end #End of if bad test
  end #End of test image url

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title, description: "yyy", price: 1, image_url: "fred.gif")
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
  end #End of test for uniqueness

  test "product is not valid without a unique title - i18n" do
    product = Product.new(title: products(:ruby).title, description: "yyy", price: 1, image_url: "fred.gif")
    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join('; ')
  end #End of test for uniqueness
end #End of class
