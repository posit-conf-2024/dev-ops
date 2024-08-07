library(palmerpenguins)
library(dplyr)
library(ggplot2)

df <- palmerpenguins::penguins

table1 <- df %>%
  group_by(species, sex) %>%
  summarise(
    across(
      where(is.numeric), 
      \(x) mean(x, na.rm = TRUE)
      )
    ) %>%
  knitr::kable()

## Penguin Size vs Mass by Species


plot <- df %>%
  ggplot(aes(x = bill_length_mm, y = body_mass_g, color = species)) +
  geom_point() + 
  geom_smooth(method = "lm")