module AuthenticationHelper
  def authenticate(username, password)
    params = {
      username: username,
      password: password
    }
    post '/api/v1/users/login', headers: headers, params: params
    json = JSON.parse(response.body).deep_symbolize_keys
    ENV['ACCESS_TOKEN'] = json[:token]

    User.where(username: username, active: true).first
  end

  def headers
    @headers ||= {}
    @headers['ACCEPT'] = 'application/json'
    @headers['HTTP_AUTHORIZATION'] = "Bearer #{ENV['ACCESS_TOKEN']}"

    @headers
  end
end
