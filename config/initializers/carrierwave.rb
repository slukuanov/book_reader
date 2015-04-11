CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => 'AKIAIB3PA4GZAMGVRE7Q',                        # required
      :aws_secret_access_key  => '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',
      # :region                 => 'us-west-2'   # required
  }
  config.fog_public     = true                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}

  if(Rails.env.production?)
    config.fog_directory  = 'funobby-dev'                     # required
  end

end