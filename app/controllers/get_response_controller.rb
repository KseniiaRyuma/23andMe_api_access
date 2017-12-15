class GetResponseController < ActionController::Base
  protect_from_forgery with: :exception

  require 'net/http'
  require 'openssl'
  require 'json'

  def get_token
  	@code = params[:code]
  	receive_token params[:code]
  	# redirect_to :controller => 'home', :action => 'index'
  end

  def receive_token(code)
	uri = URI.parse("https://api.23andme.com/token")
	https = Net::HTTP.new(uri.host, uri.port)
	https.use_ssl = true
	https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})

    request.set_form_data({"client_id"     => 'bc81e2eb4fa77a0a8a2344aa99b5fb1e',
                           "client_secret" => 'd19160ac880a0d7a13abb87b90f66d8e',
                           "grant_type"    => 'authorization_code',
                           "code"          => code,
                           "redirect_uri"  => 'http://localhost:3000/receive_code/',
                           "scope"         => 'names basic email report:all'})

    response = https.request(request)
    data = JSON.load response.read_body

    puts data
    get_account_id(data["access_token"])
  end

  def get_account_id(access_token)

  	# session[:access_token] = access_token

  	# Company.find_by_id(session[:company_id])


	puts "get_account"
	puts 'bearer' + " #{access_token}"
	uri = URI.parse("https://api.23andme.com/3/account/")
	https = Net::HTTP.new(uri.host, uri.port)
	https.use_ssl = true
	https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.path, initheader = {'Content-Type' =>'application/json'})

    # request.set_form_data({"Authorization" => 'bearer' + " #{access_token}"})
    request['authorization'] = "bearer #{access_token}"

    response = https.request(request)
    data = JSON.load response.read_body

    account_id = data['data'][0]['profiles'][0]['id']
    puts account_id

    @first_name = data['data'][0]['first_name']
    @last_name = data['data'][0]['last_name']
    @email = data['data'][0]['email']

  end

end