module GeocoderStubs
  addresses = [
    ["Chicago", [{
      'latitude'     => 41.8781136,
      'longitude'    => -87.6297982,
      'address'      => 'Chicago, IL, USA',
      'state'        => 'Illinois',
      'state_code'   => 'IL',
      'country'      => 'United States',
      'country_code' => 'US'
    }]],
    ["Skokie", [{
      'latitude' => 42.0324025,
      'longitude' => -87.7416246,
      'address' => 'Skokie, IL, USA',
      'state' => 'Illinois',
      'state_code' => 'IL',
      'country' => 'United States',
      'country_code' => 'US'
    }]],
    ["San Francisco", [{
      'latitude' => 37.7749295,
      'longitude' => -122.4194155,
      'address' => 'San Francisco, CA, USA',
      'state' => 'California',
      'state_code' => 'CA',
      'country' => 'United States',
      'country_code' => 'US'
    }]],
    ["Denver", [{
      'latitude' => 39.7392,
      'longitude' => -104.9903,
      'address' => 'Denver, CO, USA',
      'state' => 'Colorado',
      'state_code' => 'CO',
      'country' => 'United States',
      'country_code' => 'US'
    }]]
  ]

  Geocoder.configure( :lookup => :test )
  addresses.each { |address| Geocoder::Lookup::Test.add_stub(address[0], address[1])}
end
