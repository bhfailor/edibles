##
# TODO: update this class comment
# This class pulls specific nutrition data for a food that is present in the
# United States Department of Agriculture, Agricultural Research Service,
# National Nutrient Database (https://ndb.nal.usda.gov/ndb/doc/index)
class Food::Calculator
  attr_reader :results

  def initialize(args = {})
    @sources = args[:sources]
    @food    = args[:food]
    @results = {}
    @sources.each do |s|
      if /\d{3}/.match s
        parse_nutrient(s)
      else
        send(s.to_sym) if respond_to? s.to_sym
      end
    end
  end

  def parse_nutrient(nutrient_id)
    n = nutrient_hash[nutrient_id]
    if n
      @results[nutrient_id] =
        { name: n['name'], unit: n['unit'], value: n['value'] }
    else
      nil
    end
    'ok'
  end

  def nutrient_hash
    @nh ||= begin
              nhash = {}
              @food['nutrients'].each { |n| nhash[n['nutrient_id']] = n }
              nhash
            end
  end

  class << self
    def define(name, &block) # see ActiveSupport::Testing::Declarative#test
      name_sym = name.to_sym
      fail "#{name_sym} already defined in #{self}" if method_defined? name_sym
      return define_method(name_sym, &block) if block_given?
      define_method(name_sym) { flunk "No implementation for #{name}" }
    end
  end

  define('name')             { foo(key: __callee__) }
  define('dft')              { foo(value: '100', key: __callee__) }
  define('ndbno')            { foo(key: __callee__) }
  define('calc omega-3')     { foo(value: omega_3_value, key: __callee__) }
  define('calc omega-6')     { foo(value: omega_6_value, key: __callee__) }
  define('calc carb Cal')    { foo(value: carb_cals, key: __callee__) }
  define('calc fat Cal')     { foo(value: fat_cals, key: __callee__) }
  define('calc protein Cal') { foo(value: protein_cals, key: __callee__) }
  define('calc alcohol Cal') { foo(value: alcohol_cals, key: __callee__) }
  define('food price')       { foo(value: 'user-specified', key: __callee__) }
  define('vegetable grams')  { foo(value: 'user-specified', key: __callee__) }
  define('fruit grams')      { foo(value: 'user-specified', key: __callee__) }

  def carb_cals
    calories_from[:carbs].to_s
  end
  def fat_cals
    calories_from[:fat].to_s
  end
  def protein_cals
    calories_from[:protein].to_s
  end
  def alcohol_cals
    calories_from[:alcohol].to_s
  end

  def keys_for_calorie_calcs
    { calories: '208', carbs: '205', fat: '204', protein: '203',
      alcohol: '221' }
  end

  def cals_per_gram
    { carbs: 4.0, fat: 9.0, protein: 4.0, alcohol: 7.0 }
  end

  def calorie_totals
    totals = {}
    keys_for_calorie_calcs.each do |k, v|
      totals[k] = nutrient_hash[v] ? nutrient_hash[v]['value'].to_f : 0.0
    end
    totals
  end

  def calories
    @calories ||=
      begin
        calories = { by_group: {}, sum: 0.0 }
        cals_per_gram.each do |k, v|
          calories[:by_group][k] = calorie_totals[k]*v
          calories[:sum] += calories[:by_group][k]
        end
        calories
      end
  end

  def calories_from
    final_values = {}
    largest = 0.0
    largest_key = nil
    calories[:by_group].each do |k, v|
      final_values[k] = (v*calorie_totals[:calories]/calories[:sum]).round(1)
      if final_values[k] > largest
        largest = final_values[k]
        largest_key = k
      end
    end
    final_values[largest_key] = calorie_totals[:calories]
    (final_values.keys - [largest_key]).each do |k|
      final_values[largest_key] -= final_values[k]
    end
    final_values
  end

  def omega_3_value
    sum = 0.0
    %w(851 627 852 629 857 631 621).each do |key|
      sum += nutrient_hash[key] ? nutrient_hash[key]['value'].to_f*1000 : 0.0
    end
    sum.to_s # assume nutrient units are grams
  end

  def omega_6_value
    sum = 0.0
    %w(675 685 672 853 855 858).each do |key|
      sum += nutrient_hash[key] ? nutrient_hash[key]['value'].to_f*1000 : 0.0
    end
    sum.to_s # assume nutrient units are grams
  end

   def foo(args = {})
    key = args[:key].to_s
    indx = Food::SOURCES.index(key)
    @results[key] = { name: Food::NAMES[indx],
      unit: Food::UNITS[indx], value: args[:value] || @food[key] }
  end
end

=begin
  attr_reader :errors, :results

  UNITS = 'string,,g,,USD,,g,,g,,calorie,,calorie,,calorie,,calorie,,calorie' \
          ',,g,,g,,g,,g,,g,,,,g,,g,,g,,g,,g,,mg,,mg,,g,,g,,IU,,mg,,mcg,,mg,,' \
          'mcg,,mg,,mg,,mg,,mg,,mcg,,mcg,,mg,,mg,,mg,,mg,,mg,,mg,,mg,,mg,,mg' \
          ',,mg,,mg,,mg,,mcg,,mcg,,mg,,mg,,g,,g,,g,,mg,,mg,,string'.split(',,')
  SOURCES = \
  'name,,dft,,food price,,vegetable grams,,fruit grams,,208,,calc carb Cal,,' \
  'calc fat Cal,,calc protein Cal,,calc alcohol Cal,,205,,291,,209,,269,,204' \
  ',,606,,645,,646,,605,,693,,695,,calc omega-3,,calc omega-6,,203,,510,,318' \
  ',,401,,328,,323,,430,,404,,405,,406,,415,,417,,418,,410,,421,,454,,301,,3' \
  '03,,304,,305,,306,,307,,309,,312,,315,,317,,313,,601,,636,,221,,255,,207,' \
  ',262,,263,,ndbno'.split(',,')
  NAMES = \
  'food,,base mass,,price,,vegetable mass,,fruit mass,,energy (E),,carbohydr' \
  'ate E,,fat E,,protein E,,alcohol E,,total carbohydrates,,fiber,,starch,,s' \
  'ugars,,total fat,,saturated fat,,monounsaturated fat,,polyunsaturated fat' \
  ',,total trans fat,,trans-monoeonic,,trans-polyenoic,,omega-3,,omega-6,,pr' \
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
    # calc = Food::Calculator.new(sources: SOURCES,
    #   food: body['report']['food']).calculation
    @results = {
      units: \
        'string,,g,,USD,,g,,g,,calorie,,calorie,,calorie,,calorie,,calorie' \
        ',,g,,g,,g,,g,,g,,,,g,,g,,g,,g,,g,,mg,,mg,,g,,g,,IU,,mg,,mcg,,mg,,' \
        'mcg,,mg,,mg,,mg,,mg,,mcg,,mcg,,mg,,mg,,mg,,mg,,mg,,mg,,mg,,mg,,mg' \
        ',,mg,,mg,,mg,,mcg,,mcg,,mg,,mg,,g,,g,,g,,mg,,mg,,string'.split(',,')
    }
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
=end
