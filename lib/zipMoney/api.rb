module ZipMoney
  class Api 

    attr_accessor :options, :config, :payload, :response

    HTTP_METHOD_POST  = :post
    HTTP_METHOD_GET   = :get

    # Initializes a new api object
    #
    # @param [conf] ZipMoney::Configuration
    # @param [options] api options
    #
    # @return ZipMoney::Api instance
    def initialize(conf,options={})         
      if conf.new.class == ZipMoney::Configuration
        @config = conf
      else
        raise ArgumentError, "Config is not valid"
      end
      @options = options
    end
    
    # Appends api credentials to the request object
    #
    # @param [data] Request data
    #
    # @return data
    def append_api_credentials(params)
      is_param_defined(params) do
        params = Struct::ApiCredentials.new
        params.version = Struct::Version.new
      end 
      if params.merchant_id  == nil 
         params.merchant_id  = self.config.merchant_id
      end
      if params.merchant_key == nil
         params.merchant_key = self.config.merchant_key
      end
      if params.version.client == nil
         params.version.client = ZipMoney::Configuration::API_NAME + " Version:" + ZipMoney::Configuration::API_VERSION
      end
      if params.version.platform == nil
         params.version.platform = ZipMoney::Configuration::API_PLATFORM
      end
      params  
    end 

    # Checks if data is a Struct and calls the block passed as parameter if true
    #
    # @param [data] Request data
    #
    # @return true|false
    def is_param_defined(params)
      yield if !params.is_a?(Struct) 
    end 

    # Makes request to the zipMoney endpoint
    #
    # @param [resource] endpoint resource 
    # @param [method] method  get|post
    # @param [params] request parameters
    #
    # @return ZipMoney::Response object
    def request(resource, method,  params = nil)      
      resource = Resources.get(resource, method, params)
      params   = append_api_credentials(params)

      if method == :post
        payload = prepare_params(params)
      else
        payload = {}
      end

      headers = @options[:headers] || {}
      if method == :get 
        resource.send(method, headers) do |response, request, result, &block| 
            ZipMoney::Response.new(response)
        end
      else
        resource.send(method, payload, headers) do |response, request, result, &block|
          ZipMoney::Response.new(response)
        end
      end
    end
    
    # Converts the parameters(Hash) to json
    #
    # @param [params] request parameters
    #
    # @return data as json
    def prepare_params(params)
      begin
        params =  Util.struct_to_hash(params).to_json
      rescue TypeError => e
        if params.is_a?(Hash)
          params = params.to_json
        else  
          raise ArgumentError, "Invalid params provided" 
        end
      rescue JSON::ParserError => e
        if params.is_a?(Hash)
           params = params.to_json
        else  
          raise ArgumentError, "Invalid params provided" 
        end
      end
      params
    end 

    # Makes checkout call on the zipMoney endpoint
    #
    # @param [params] request parameters
    #
    # @return ZipMoney::Response object
    def checkout(params)
      request(Resources::RESOURCE_CHECKOUT, HTTP_METHOD_POST, params)
    end 
    
    # Makes quote call on the zipMoney endpoint
    #
    # @param [params] request parameters
    #
    # @return ZipMoney::Response object
    def quote(params)
      request(Resources::RESOURCE_QUOTE, HTTP_METHOD_POST, params)
    end 
    
    # Makes capture call on the zipMoney endpoint
    #
    # @param [params] request parameters
    #
    # @return ZipMoney::Response object
    def capture(params)
      request(Resources::RESOURCE_CAPTURE, HTTP_METHOD_POST, params)
    end 
    
    # Makes refund call on the zipMoney endpoint
    #
    # @param [params] request parameters
    #
    # @return ZipMoney::Response object
    def refund(params)
      request(Resources::RESOURCE_REFUND, HTTP_METHOD_POST, params)
    end 

    # Makes cancel call on the zipMoney endpoint
    #
    # @param [params] request parameters
    #
    # @return ZipMoney::Response object
    def cancel(params)
      request(Resources::RESOURCE_CANCEL, HTTP_METHOD_POST, params)
    end 

    # Makes query call on the zipMoney endpoint
    #
    # @param [params] request parameters
    #
    # @return ZipMoney::Response object
    def query(params)
      request(Resources::RESOURCE_QUERY, HTTP_METHOD_POST, params)
    end 

    # Makes configure call on the zipMoney endpoint
    #
    # @param [params] request parameters
    #
    # @return ZipMoney::Response object
    def configure(params)
      request(Resources::RESOURCE_CONFIGURE, HTTP_METHOD_POST, params)
    end 

    # Makes settings call on the zipMoney endpoint
    #
    # @param [params] request parameters
    #
    # @return ZipMoney::Response object
    def settings
      request(Resources::RESOURCE_SETTINGS, HTTP_METHOD_POST)
    end 

    # Makes heartbeat call on the zipMoney endpoint
    #
    # @param [params] request parameters
    #
    # @return ZipMoney::Response object
    def heartbeat
      request(Resources::RESOURCE_HEARTBEAT, HTTP_METHOD_POST)
    end 
  end
end