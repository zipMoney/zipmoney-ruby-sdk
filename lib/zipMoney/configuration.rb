module ZipMoney
	class Configuration
		
		API_VERSION  = "1.0.1"
		API_PLATFORM = "ruby"
		API_NAME	   = "zipMoney Ruby SDK"

    ENV_LIVE_API_URL = "https://api.zipmoney.com.au/v1/"
    ENV_TEST_API_URL = "https://api.sandbox.zipmoney.com.au/v1/"

    ATTRIBUTES = [
      :merchant_id,
      :merchant_key,
      :environment,
    ]

  	attr_accessor *ATTRIBUTES

    class << self
     	attr_accessor *ATTRIBUTES

			# Checks if passed value is valid and assigns it true
			#
			# @param [env] Environment sandbox|live
			#
			# @return true|false
    	def environment=(env)
      	env = env.to_sym
      	raise ArgumentError, "#{env.inspect} is not a valid environment"   unless [:sandbox, :live].include?(env)
      	@environment = env
    	end

    	# Checks if environment is sandbox
    	#
			# @return true|false
    	def is_sandbox
    		environment.to_s == "sandbox"
   		end

			# Checks if passed merchant_id and merchant_key match with the one provided during setup
			#
			# @param [merchant_id] Merchant Id
			# @param [merchant_key] Merchant Key
   		def credentials_valid(merchant_id,merchant_key)
    		raise ExpressError, "Invalid merchant credentials in the request" unless @merchant_id.to_i.eql?(merchant_id.to_i) && @merchant_key.to_s.eql?(merchant_key.to_s)
    	end
    end
	end
end