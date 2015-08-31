class SearchController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :add_headers

  def new
    search = search_client.get(params['searchId'])
    place_ids = search.body["places"]
    place_ids.each do |place_id, _|
      place = place_client.get(place_id).body
      data = {
        to: place['phone'],
        # to: "17078496085",
        from: "14157636769",
        record: true,
        if_machine: "Hangup",
        status_callback: "#{ENV['BASE_URL']}/status_callback?place_id=#{place_id}&search_id=#{params['searchId']}",
        url: "#{ENV['BASE_URL']}/init_call?place_id=#{place_id}&search_id=#{params['searchId']}"
      }
      twilio = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']
      twilio.account.calls.create data
    end

    render json: {success: true}
  end

  def init_call
    place_id = params["place_id"]
    search_id = params["search_id"]

    place = place_client.get(place_id).body
    @search = search_client.get(search_id).body

    @post_to = "#{ENV['BASE_URL']}/handle_response?place_id=#{place_id}&search_id=#{params['searchId']}"
    render action: "init_call.xml.builder", :layout => false
  end

  def handle_response
    place_id = params["place_id"]
    place = place_client.get(place_id).body

    if params["Digits"] == "1"
      place_client.update(place_id, {response: "in stock"})
    else
      place_client.update(place_id, {response: "not in stock"})
    end

    render action: 'goodbye.xml.builder', :layout => false
  end

  def status_callback
    place_id = params["place_id"]
    place = place_client.get(place_id).body

    place_client.update(place_id, {status: "complete"})

    render :nothing => true
  end

  private

  def search_client
    Firebase::Client.new("https://booz-club.firebaseio.com/searches/")
  end

  def place_client
    Firebase::Client.new("https://booz-club.firebaseio.com/places/")
  end

  def add_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
end
