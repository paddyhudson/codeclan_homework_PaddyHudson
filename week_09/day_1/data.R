borders <- read_csv("data/opendata_inc9519_hb.csv") %>%
  clean_names() %>% 
  filter(hb == "S08000016") %>% 
  mutate(area = "NHS Borders")
region <- read_csv("data/opendata_inc9519_region.csv") %>%  clean_names()
scotland <- read_csv("data/opendata_inc9519_scotland.csv") %>% clean_names()

scotland <- scotland %>% 
  select(-(incidences_age_under5:incidences_age90and_over),
         -(incidence_rate_age_under5:incidence_rate_age90and_over)) %>% 
  mutate(area = "Scotland")

jborders <- borders %>%
  left_join(scotland, by = c("cancer_site" = "cancer_site", "sex" = "sex", "sex_qf" = "sex_qf", "year" = "year"))