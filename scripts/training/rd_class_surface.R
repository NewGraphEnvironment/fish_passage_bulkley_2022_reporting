
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
           my_road_surface,
           crossing_fix,
           recommended_diameter_or_span_meters,
           source,
           downstream_channel_width_meters,
           habitat_value,
           barrier_result
          ) %>%
  #filter out crossings that aren't barriers
  filter(!is.na(crossing_fix)) %>%
  # burn out
  readr::write_csv('data/inputs_raw/rd_class_surface.csv')

## NOTE: my_road_class and my_road_surface columns were filled in after the fact, using Roads-DRA layer in Q and matching to bcbarriers
## my_road_class was determined by matching transport_line_type_code in roads layer to code in whse_basemapping.transport_line_type_code
# my_road_surface was determined by matching transport_line_surface_code in roads layer to code in whse_basemapping.transport_line_surface_code
