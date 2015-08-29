xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1) do
    xml.Play "https://s3-us-west-2.amazonaws.com/booz-club/alc_hello.mp3"
    xml.Say @search["boozType"]
    xml.Play "https://s3-us-west-2.amazonaws.com/booz-club/alc_thanks.mp3"
    xml.Play "https://s3-us-west-2.amazonaws.com/booz-club/boozclub.mp3"
    xml.Play "https://s3-us-west-2.amazonaws.com/booz-club/alc_hello.mp3"
    xml.Say @search["boozType"]
    xml.Play "https://s3-us-west-2.amazonaws.com/booz-club/alc_thanks.mp3"
    xml.Play "https://s3-us-west-2.amazonaws.com/booz-club/boozclub.mp3"
  end
end
