require 'spec_helper'


describe ZipMoney::Api do
  	
  	before :each do
  		# Setup the gateway for testing
      ZipMoney::Configuration.merchant_id  = 86
      ZipMoney::Configuration.merchant_key = "QCXlS0BOrFl+hkd2fbSR7ujEuDP4WZECYw4oB0il5eE="
      ZipMoney::Configuration.environment  = 'sandbox'

      @order_id = '%010d' % rand(10 ** 10)
 
  	end

  	it "should make settings request" do
     	
      settings = ZipMoney::Settings.new
      response = settings.do()
      
      response.isSuccess.should be_truthy
      response.toObject.Settings.should_not be_nil
  	end

    # Checkout
    it "should make checkout request and return redirect_url" do 

      checkout_json = JSON.parse(File.read("spec/fixtures/checkout.json"))

      # Request 
      checkout = ZipMoney::Checkout.new
      params   = checkout.params

      params.charge        = checkout_json["charge"]
      params.currency_code = checkout_json["currency_code"]
      params.txn_id        = checkout_json["txn_id"]
      params.return_url    = checkout_json["return_url"]
      params.cancel_url    = checkout_json["cancel_url"]
      params.notify_url    = checkout_json["notify_url"]
      params.error_url     = checkout_json["error_url"]
      params.in_store      = checkout_json["in_store"]
      params.order_id      = @order_id

      params.order.id              = @order_id
      params.order.tax             = checkout_json["order"]["tax"]
      params.order.shipping_value  = checkout_json["order"]["shipping_value"]
      params.order.total           = checkout_json["order"]["total"]

      item = Struct::Detail.new
      
      item.quantity = checkout_json["order"]["detail"][0]["quantity"]
      item.name     = checkout_json["order"]["detail"][0]["name"]
      item.price    = checkout_json["order"]["detail"][0]["price"]
      item.id       = checkout_json["order"]["detail"][0]["id"]

      params.order.detail.push(item)

      params.billing_address.first_name = checkout_json["billing_address"]["first_name"]
      params.billing_address.last_name  = checkout_json["billing_address"]["last_name"]
      params.billing_address.line1      = checkout_json["billing_address"]["line1"]
      params.billing_address.line2      = checkout_json["billing_address"]["line2"]
      params.billing_address.country    = checkout_json["billing_address"]["country"]
      params.billing_address.zip        = checkout_json["billing_address"]["zip"]
      params.billing_address.city       = checkout_json["billing_address"]["city"]
      params.billing_address.state      = checkout_json["billing_address"]["state"]
      
      params.shipping_address.first_name = checkout_json["shipping_address"]["first_name"]
      params.shipping_address.last_name  = checkout_json["shipping_address"]["last_name"]
      params.shipping_address.line1      = checkout_json["shipping_address"]["line1"]
      params.shipping_address.line2      = checkout_json["shipping_address"]["line2"]
      params.shipping_address.country    = checkout_json["shipping_address"]["country"]
      params.shipping_address.zip        = checkout_json["shipping_address"]["zip"]
      params.shipping_address.city       = checkout_json["shipping_address"]["city"]
      params.shipping_address.state      = checkout_json["shipping_address"]["state"]

      params.consumer.first_name = checkout_json["consumer"]["first_name"]
      params.consumer.last_name  = checkout_json["consumer"]["last_name"]
      params.consumer.phone      = checkout_json["consumer"]["phone"]
      params.consumer.gender     = checkout_json["consumer"]["gender"]
      params.consumer.email      = checkout_json["consumer"]["email"]
      params.consumer.dob        = checkout_json["consumer"]["dob"]
      params.consumer.title      = checkout_json["consumer"]["title"]

      response = checkout.do()      
      response.isSuccess.should be_truthy
    end 

    # Quote
    it "should make quote request and return redirect_url" do 

      quote_json = JSON.parse(File.read("spec/fixtures/quote.json"))

      # Request 
      quote = ZipMoney::Quote.new

      params = quote.params

      params.currency_code = quote_json["currency_code"]
      params.txn_id        = quote_json["txn_id"]
      params.cart_url      = quote_json["cart_url"]
      params.success_url   = quote_json["success_url"]
      params.cancel_url    = quote_json["cancel_url"]
      params.error_url     = quote_json["error_url"]
      params.refer_url     = quote_json["refer_url"]
      params.decline_url   = quote_json["decline_url"]
      params.in_store      = quote_json["in_store"]
      params.quote_id      = quote_json["quote_id"]
      params.checkout_source = quote_json["checkout_source"]

      params.order.id              = quote_json["order"]["id"]
      params.order.tax             = quote_json["order"]["tax"]
      params.order.shipping_value  = quote_json["order"]["shipping_value"]
      params.order.total           = quote_json["order"]["total"]

      item = Struct::Detail.new
      
      item.quantity = quote_json["order"]["detail"][0]["quantity"]
      item.name     = quote_json["order"]["detail"][0]["name"]
      item.price    = quote_json["order"]["detail"][0]["price"]
      item.id       = quote_json["order"]["detail"][0]["id"]
      
      params.order.detail.push(item)

      params.billing_address.first_name = quote_json["billing_address"]["first_name"]
      params.billing_address.last_name  = quote_json["billing_address"]["last_name"]
      params.billing_address.line1      = quote_json["billing_address"]["line1"]
      params.billing_address.line2      = quote_json["billing_address"]["line2"]
      params.billing_address.country    = quote_json["billing_address"]["country"]
      params.billing_address.zip        = quote_json["billing_address"]["zip"]
      params.billing_address.city       = quote_json["billing_address"]["city"]
      params.billing_address.state      = quote_json["billing_address"]["state"]
      
      params.shipping_address.first_name = quote_json["shipping_address"]["first_name"]
      params.shipping_address.last_name  = quote_json["shipping_address"]["last_name"]
      params.shipping_address.line1      = quote_json["shipping_address"]["line1"]
      params.shipping_address.line2      = quote_json["shipping_address"]["line2"]
      params.shipping_address.country    = quote_json["shipping_address"]["country"]
      params.shipping_address.zip        = quote_json["shipping_address"]["zip"]
      params.shipping_address.city       = quote_json["shipping_address"]["city"]
      params.shipping_address.state      = quote_json["shipping_address"]["state"]

      params.consumer.first_name = quote_json["consumer"]["first_name"]
      params.consumer.last_name  = quote_json["consumer"]["last_name"]
      params.consumer.phone      = quote_json["consumer"]["phone"]
      params.consumer.gender     = quote_json["consumer"]["gender"]
      params.consumer.email      = quote_json["consumer"]["email"]
      params.consumer.dob        = quote_json["consumer"]["dob"]
      params.consumer.title      = quote_json["consumer"]["title"]

      response = quote.do()
      response.isSuccess.should be_truthy
    
    end 

    # Capture
    it "should make capture request" do 

      capture_json = JSON.parse(File.read("spec/fixtures/capture.json"))

      # Request 
      capture = ZipMoney::Capture.new

        capture.params.txn_id        = capture_json["txn_id"]
        capture.params.order_id      = @order_id

        capture.params.order.id              = @order_id
        capture.params.order.tax             = capture_json["order"]["tax"]
        capture.params.order.shipping_value  = capture_json["order"]["shipping_value"]
        capture.params.order.total           = capture_json["order"]["total"]

        capture.params.order.detail[0] = Struct::Detail.new
        
        item = capture_json["order"]["detail"]

        capture.params.order.detail[0].quantity = item[0]["quantity"]
        capture.params.order.detail[0].name  = item[0]["name"]
        capture.params.order.detail[0].price = item[0]["price"]
        capture.params.order.detail[0].id    = item[0]["id"]

      response = capture.do()
      response.isSuccess.should be_truthy

    end 

    # Refund 
    it "should make refund request" do 

      refund_json = JSON.parse(File.read("spec/fixtures/refund.json"))

      # Request 
      refund = ZipMoney::Refund.new

        refund.params.reason        = refund_json["reason"]
        refund.params.refund_amount = refund_json["refund_amount"]
        refund.params.txn_id        = refund_json["txn_id"]
        refund.params.order_id      = @order_id

        refund.params.order.id              = @order_id
        refund.params.order.tax             = refund_json["order"]["tax"]
        refund.params.order.shipping_value  = refund_json["order"]["shipping_value"]
        refund.params.order.total           = refund_json["order"]["total"]

        refund.params.order.detail[0] = Struct::Detail.new
        
        item = refund_json["order"]["detail"]

        refund.params.order.detail[0].quantity = item[0]["quantity"]
        refund.params.order.detail[0].name  = item[0]["name"]
        refund.params.order.detail[0].price = item[0]["price"]
        refund.params.order.detail[0].id  = item[0]["id"]

      response = refund.do()
      response.isSuccess.should be_truthy
    end 

    # Cancel 
    it "should make cancel request" do 

      cancel_json = JSON.parse(File.read("spec/fixtures/cancel.json"))

      # Request 
      cancel = ZipMoney::Cancel.new

        cancel.params.txn_id        = cancel_json["txn_id"]
        cancel.params.order_id      = @order_id

        cancel.params.order.id              = @order_id
        cancel.params.order.tax             = cancel_json["order"]["tax"]
        cancel.params.order.shipping_value  = cancel_json["order"]["shipping_value"]
        cancel.params.order.total           = cancel_json["order"]["total"]

        cancel.params.order.detail[0] = Struct::Detail.new
        
        item = cancel_json["order"]["detail"]

        cancel.params.order.detail[0].quantity = item[0]["quantity"]
        cancel.params.order.detail[0].name  = item[0]["name"]
        cancel.params.order.detail[0].price = item[0]["price"]
        cancel.params.order.detail[0].id  = item[0]["id"]

      response = cancel.do()
      response.isSuccess.should be_truthy
    end 

    # Query 
    it "should make query request" do 

      query_json = JSON.parse(File.read("spec/fixtures/query.json"))

      # Request 
      query = ZipMoney::Query.new

        query.params.orders[0] = Struct::QueryOrder.new
        query.params.orders[0].id     = @order_id

      response = query.do()
      response.isSuccess.should be_truthy
    end 
end	
