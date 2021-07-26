# Scraper for Vaccinate the States API. Queries every GeoJSON file and outputs the scraped data.

library(jsonlite)
library(dplyr)
library(tidyr)
library(readr)

# get state abbreviations
states <- state.abb

# build url for queries
baseurl <- "https://api.vaccinatethestates.com/v0/"

national_data <- data.frame()

for (i in 1:length(states)) {

  # build URL for API query
  state_url <- paste0(baseurl,states[i],".geojson")

  # grab data for a single state
  state_data <- fromJSON(state_url,flatten=TRUE)[["features"]]

  # clean up the coordinates
  state_data$lon <- strsplit(as.character(unlist(state_data$geometry.coordinates)), " ")[[1]]
  state_data$lat <- strsplit(as.character(unlist(state_data$geometry.coordinates)), " ")[[2]]

  # combine
  national_data <- rbind(national_data,state_data)
  cat(paste("Scraped data for state:",states[i],"\n"))
}

# write out time for diagnostic purposes
cat(paste("Scraper finished at",Sys.time()))

# write out the scraped data
write_csv(national_data,"vaccinatethestates.csv")
