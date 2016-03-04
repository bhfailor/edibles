class Food
  attr_reader :errors
  AUTH = '&api_key=' + ENV['DATA_DOT_GOV_API_KEY']
  BASE = 'http://api.nal.usda.gov/ndb/reports/?'

  def initialize(args = {})
    @code = args[:code]
    assign_results unless errors_exist
  end

  def assign_results
  end

  def errors_exist
    @errors =
      (body["errors"] ?
       "#{body['errors']['error'].first['message']}: #{@code}" : nil)
    return @errors ? true : false
  end

  def body
    @body ||= begin
                http = Net::HTTP.new(url.host, url.port)
                response = http.request(Net::HTTP::Get.new(url))
                JSON.parse(response.read_body)
              end
  end

  def url
    @url ||= begin
               data = URI.encode_www_form(ndbno: @code, type: 's',
                                          format: 'json')
               URI.parse(BASE + data + AUTH)
             end
  end

end
