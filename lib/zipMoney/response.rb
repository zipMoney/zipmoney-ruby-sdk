module ZipMoney
  class Response
        
    attr_accessor :_response , :_responseBody, :_responseHeader, :_statusCode

    # Initializes a new api response object
    #
    # @param [response] response 
    #
    # @return ZipMoney::Response object
    def initialize(response)
      raise ArgumentError, "Response doesnot exist" if ((response.nil? || response.empty?) && response.code.nil? && response.code.empty?)
      @_response       = response
      @_statusCode     = response.code
      @_responseBody   = response.body
    end         
    
    # Converts the response body to Hash
    #
    # @return Hash
    def toHash
      raise ResponseError, "Response body doesnot exist" if @_responseBody.nil? || @_responseBody.empty?
      JSON.parse(@_responseBody) 
    end
    
    # Converts the response body to Object
    #
    # @return OpenStruct
    def toObject
      raise ResponseError, "Response body doesnot exist" if @_responseBody.nil? || @_responseBody.empty?
      responseObjectHash = JSON.parse(@_responseBody, object_class: OpenStruct)
      responseObject = OpenStruct.new(responseObjectHash)
      responseObject
    end
      
    # Returns the redirect_url from the checkout and quote calls
    #
    # @return String 
    def getRedirectUrl
      raise ArgumentError, "Response body doesnot exist" if @_responseBody.nil? || @_responseBody.empty?
      resObj = toObject
      return false if resObj.redirect_url.nil?  || resObj.redirect_url.empty?
      resObj.redirect_url
    end
      
    # Returns the http status code
    #
    # @return Int 
    def getStatusCode
      @_statusCode
    end 

    # Returns if the api call was a success or failure
    #
    # @return true|false 
    def isSuccess
      return @_statusCode == 200 || @_statusCode == 201? true : false
    end
      
    # Returns error string
    #
    # @return String 
    def getError
      raise ArgumentError, "Response body doesnot exist" if @_responseBody.nil? || @_responseBody.empty?
      resObj = toObject
      resObj.Message
    end
  end
end
