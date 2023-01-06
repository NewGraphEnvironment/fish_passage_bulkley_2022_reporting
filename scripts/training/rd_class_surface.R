
# stole this from tables.R
pscis_all_prep <- pscis_list %>%
  bind_rows()

pscis_all <- left_join(
  pscis_all_prep,
  xref_pscis_my_crossing_modelled,
  by = c('my_crossing_reference' = 'external_crossing_reference')
) %>%
  mutate(pscis_crossing_id = case_when(
    is.na(pscis_crossing_id) ~ as.numeric(stream_crossing_id),
    T ~ pscis_crossing_id
  )) %>%
  arrange(pscis_crossing_id)


pscis_all %>%
  # choose distict to eliminate redundancy
  distinct(pscis_crossing_id, my_crossing_reference, .keep_all = T) %>%
  # choosing sensible defaults
  mutate(my_road_class = 'local',
         my_road_surface = 'paved') %>%
  # just grab what we need
  select(pscis_crossing_id,
           my_crossing_reference,
           stream_name,
           road_name,
           road_tenure,
           my_road_class,
           my_road_surface) %>%
  # burn out
  readr::write_csv('data/inputs_raw/rd_class_surface.csv')
