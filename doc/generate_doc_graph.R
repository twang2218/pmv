library(eventdataR)
library(dplyr)
library(pmap)

eventlog <- eventdataR::sepsis %>%
  rename(
    timestamp = Complete_Timestamp,
    case_id = Case_ID,
    activity = Activity
  ) %>%
  mutate(
    activity_type = activity
  ) %>%
  select(timestamp, case_id, activity, activity_type) %>%
  na.omit()

p <- create_pmap(eventlog)
render_pmap(p)
render_pmap_file(p, "man/figures/example.prune_edges.none.svg", use_external_dot = TRUE)


p %>% prune_edges(0.5) %>%
  render_pmap_file("man/figures/example.prune_edges.edges.svg", use_external_dot = TRUE)

p %>% prune_nodes(0.5) %>% prune_edges(0.5) %>%
  render_pmap_file("man/figures/example.prune_edges.both.svg", use_external_dot = TRUE)

p <- create_pmap(eventlog, distinct_repeated_activities = TRUE)
p %>% prune_nodes(0.5) %>% prune_edges(0.93) %>% render_pmap()
p %>% prune_nodes(0.5) %>% prune_edges(0.93) %>%
  render_pmap_file("man/figures/example.distinct_repeated_activities.svg", use_external_dot = TRUE)

# create_pmap()

eventlog <- data.frame(
  timestamp = c(
    as.POSIXct("2017-10-01"),
    as.POSIXct("2017-10-02"),
    as.POSIXct("2017-10-03"),
    as.POSIXct("2017-10-04"),
    as.POSIXct("2017-10-05"),
    as.POSIXct("2017-10-06"),
    as.POSIXct("2017-10-07"),
    as.POSIXct("2017-10-08"),
    as.POSIXct("2017-10-09"),
    as.POSIXct("2017-10-10")
  ),
  case_id = c("c1", "c1", "c1", "c1", "c1", "c1", "c1", "c1", "c1", "c1"),
  activity =  c("a",  "b",  "d",  "a",  "c",  "a",  "b",  "c",  "a",  "d"),
  category =  c("campaign", "campaign", "sale", "campaign", "sale", "campaign", "campaign", "sale", "campaign", "sale"),
  stringsAsFactors = FALSE
)

create_pmap(eventlog, target_categories = c("sale")) %>%
  render_pmap_file("man/figures/example.create_pmap.simple.svg", use_external_dot = TRUE)


eventlog <- generate_eventlog(
  size_of_eventlog = 10000,
  number_of_cases = 2000,
  categories = c("campaign", "sale"),
  categories_size = c(8, 2))

create_pmap(eventlog, target_categories = c("sale")) %>%
  render_pmap_file("man/figures/example.create_pmap.complex.svg", use_external_dot = TRUE)
