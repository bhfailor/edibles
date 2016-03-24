##
# This class pulls specific nutrition data for a food that is present in the
# United States Department of Agriculture, Agricultural Research Service,
# National Nutrient Database (https://ndb.nal.usda.gov/ndb/doc/index)
class Food
  attr_reader :errors, :results

  UNITS = 'string,,g,,USD,,g,,g,,calorie,,calorie,,calorie,,calorie,,calorie' \
          ',,g,,g,,g,,g,,g,,,,g,,g,,g,,g,,g,,mg,,mg,,g,,g,,IU,,mg,,mcg,,mg,,' \
          'mcg,,mg,,mg,,mg,,mg,,mcg,,mcg,,mg,,mg,,mg,,mg,,mg,,mg,,mg,,mg,,mg' \
          ',,mg,,mg,,mg,,mcg,,mcg,,mg,,mg,,g,,g,,g,,mg,,mg,,string'.split(',,')
  SOURCES = \
  'name,,dft,,food price,,vegetable grams,,fruit grams,,208,,calc carb Cal,,' \
  'calc fat Cal,,calc protein Cal,,calc alcohol Cal,,205,,291,,209,,269,,204' \
  ',,606,,645,,646,,605,,693,,695,,calc omega-3,,calc omega-6,,203,,501,,318' \
  ',,401,,328,,323,,430,,404,,405,,406,,415,,417,,418,,410,,421,,454,,301,,3' \
  '03,,304,,305,,306,,307,,309,,312,,315,,317,,313,,601,,636,,221,,255,,207,' \
  ',262,,263,,ndbno'.split(',,')
  NAMES = \
  'food,,base mass,,price,,vegetable mass,,fruit mass,,energy (E),,carbohydr' \
  'ate E,,fat E,,protein E,,alcohol E,,total carbohydrates,,fiber,,starch,,s' \
  'ugars,,total fat,,saturated fat,,monounsaturated fat,,polyunsaturated fat' \
  ',,total trans fat,,trans-monoenoic,,trans-polyenoic,,omega-3,,omega-6,,pr' \
  'otein,,tryptophan,,vitamin A,,vitamin C,,vitamin D,,vitamin E,,vitamin K,' \
  ',thiamine,,riboflavin,,niacin,,vitamin B6,,folate,,vitamin B12,,pantothen' \
  'ic acid,,choline,,betaine,,calcium,,iron,,magnesium,,phosphorus,,potassiu' \
  'm,,sodium,,zinc,,copper,,manganese,,selenium,,fluoride,,cholesterol,,phyt' \
  'osterols,,alcohol,,water,,ash,,caffeine,,theobromine,,ndb food number'
    .split(',,')

  def initialize(args = {})
    @num = args[:number]
    assign_results unless errors_exist
  end

  private

  AUTH = "&api_key=#{ENV['DATA_DOT_GOV_API_KEY']}"
  BASE = 'http://api.nal.usda.gov/ndb/reports/?'

  def assign_results
    @results = Food::Calculator
      .new(sources: SOURCES, food: body['report']['food']).results
  end

  def errors_exist
    @errors = "#{body['errors']['error'].first['message']}: #{@num}" \
      if body['errors']
    @errors ? true : false
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
               data = URI
                 .encode_www_form(ndbno: @num, type: 's', format: 'json')
               URI.parse(BASE + data + AUTH)
             end
  end
end
