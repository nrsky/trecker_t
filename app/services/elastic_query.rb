class ElasticQuery
 def self.records_for(driver_id, day)
       {constant_score:
            {filter:
                 {bool:
                      {must:
                           [{term:
                                 {driver_id: driver_id}},
                            {range: {timestamp: {gte: "#{day}T00:00:00", lte: "#{day}T23:59:59"}}}
                           ]
                      }
                 }
            }
       }
 end
end
