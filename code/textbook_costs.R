library(blsR)
library(tidyverse)
# Note: Use bls_set_key() to set the BLS API key.
bls_set_key("83b591c5fa1f4b308aee6c6bbaf7c0c3")
# Download data from the BLS.
cpi_data_raw <-
  get_n_series_table(
    list(
      inflation = 'CUSR0000SA0', 
      tuition = 'CUSR0000SEEB01', 
      textbooks = 'CUUR0000SSEA011'), 
    start_year = 2002, 
    end_year=2025
  )

# Set each index to be the percent change in price since January 2002.
#Got help with math for this step...
cpi_data_clean <- 
  cpi_data_raw |>
  mutate(
    inflation = 100 * (inflation / 177.7 - 1),
    tuition = 100 * (tuition / 360.7 - 1),
    textbooks = 100 * (textbooks / 101.9 - 1),
    period = as.numeric(str_remove(period, "M")),
    date= make_date(year, period)
  )

# Make a line plot of the data.
plot(
  cpi_data_clean$date, 
  cpi_data_clean$inflation, 
  type ="l")




