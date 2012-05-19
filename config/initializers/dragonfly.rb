require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)
#app.configure_with(:heroku, 'j.lab-images') if Rails.env.production?
  c.datastore = Dragonfly::DataStorage::S3DataStore.new(
    :bucket_name => 'j.lab-images',
    :access_key_id => 'AKIAJ6SR4UCCJDDU67TA',
    :secret_access_key => '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'
  )

app.define_macro(ActiveRecord::Base, :image_accessor)
