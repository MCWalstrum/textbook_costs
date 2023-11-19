library(blsR)
library(tidyverse)
# Note: Use bls_set_key() to set the BLS API key.

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
    date = make_date(year, period)
  ) |>
  select(!c(year, period)) |>
  relocate(date) |>
  # Convert data from wide to long to match tidy data standard.
  pivot_longer(
    cols = c("inflation", "tuition", "textbooks"),
    names_to = "series",
    values_to = "cpi"
  )

# Create a ggplot.
textbook_costs_chart <- 
  ggplot(data = cpi_data_clean) +
  geom_line(mapping = aes(x = date, y = cpi, color = series)) +
  labs(title = "Consumer Price Index for Tuition, Textbooks, and All Items",
       caption = "Source: Bureau of Labor Statistics",
       x = "",
       y = "Percent change from January 2002")
textbook_costs_chart

# Save the textbook_costs_chart as a PNG file
ggsave(
  "images/textbook_costs.png", 
  textbook_costs_chart, 
  width = 8, 
  height = 6, 
  units = "in", 
  dpi = 300)
