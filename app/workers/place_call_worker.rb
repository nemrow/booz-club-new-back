class PlaceCallWorker
  include Sidekiq::Worker

  def perform(search_id, place_id)
    place = place_client.get(place_id).body
    data = {
      to: place['phone'],
      # to: "17078496085",
      from: "14157636769",
      if_machine: "Hangup",
      status_callback: "#{ENV['BASE_URL']}/status_callback?place_id=#{place_id}&search_id=#{search_id}",
      url: "#{ENV['BASE_URL']}/init_call?place_id=#{place_id}&search_id=#{search_id}"
    }
    twilio_client.account.calls.create data
  end

  def twilio_client
    Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']
  end

  def place_client
    Firebase::Client.new("https://booz-club.firebaseio.com/places/")
  end
end
