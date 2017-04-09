class RecordIndex  < Chewy::Index
  define_type ::Record do
    field :timestamp
    field :driver_id
    field :speed
    field :timestamp
    field :location, type: 'geo_point', value: ->{ {lat: latitude, lon: longitude} }
    field :accuracy
  end
end
