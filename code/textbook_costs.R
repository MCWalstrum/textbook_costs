library(rjson)
library(blsAPI)
        
        response <- blsAPI('CIU1010000000000A')
        json     <- fromJSON(response)
        
        data_list  <- json$Results$series[[1]]$data[-1]
        cpi        <- data.frame(matrix(unlist(data_list), ncol = 4, byrow = TRUE, 
                                        dimnames = list(NULL, c("year", "period", 
                                                                "periodName", "value"))), 
                                 stringsAsFactors = FALSE)
        cpi
)
