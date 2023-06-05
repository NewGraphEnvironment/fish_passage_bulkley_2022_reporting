# extract moti climate change data from mergin field form and make table to insert into reporting

# source('scripts/packages.R')
# source('scripts/tables.R')

# read csv that has column names we want
xref_moti_climate <- read_csv(file = 'data/inputs_raw/xref_moti_climate.csv')

# read in data from mergin form, contains all skeena data as well so need to filter out bulk sites
moti_site_data <- read_csv(file = 'data/dff/form_pscis_moti_20230511.csv') %>%
  rename(moti_chris_culvert_id = chris_culvert_id) %>%
  # add the condition and erosion columns
  select(any_of(xref_moti_climate %>% pull(spdsht)), contains('erosion'), contains('embankment')) %>%
  # pull out sites that match pscis ids or my crossing references from bulk repo object
  # this seems a bit strange.. first section said keep if the pscis id is there or there is not a my_crossing_ref... why? works to remove Cullen but maybe coudl just remove cullen explicitly?
  filter(pscis_crossing_id %in% (pscis_all %>% pull(pscis_crossing_id))|
        !is.na(my_crossing_reference) &
        my_crossing_reference %in% (pscis_all %>% pull(my_crossing_reference))) %>%
  # condition and erosion columns were renamed condition_issues and erosion_issues
  mutate(erosion_issues = case_when(!is.na(erosion) ~ erosion, T ~ erosion_issues),
         embankment_fill_issues = case_when(!is.na(embankment_issues) ~ embankment_issues, T ~ embankment_fill_issues)) %>%
  select(-erosion, -embankment_issues, -contains('photo')) %>%
  arrange(pscis_crossing_id)


# little tests
# test <- moti_site_data %>%
#   select(date, source, stream_name, contains('erosion'), contains('embankment'))

# some pscis ids and crossing references were input wrong in mergin form, see which sites are missing by comparing to bulkley repo pscis object

# see_diff <- pscis_all %>%
#   filter(!pscis_crossing_id %in% (moti_site_data %>% pull(pscis_crossing_id))&
#            !my_crossing_reference %in% (moti_site_data %>% pull(my_crossing_reference)))
# none of them are culverts, so they don't have climate data

# filter out sites that don't have overall climate ranks, filter out duplicate sites that were not done by Mateo or AI (keep Tieasha's Perow site)
moti_data_cleaned <- moti_site_data %>%
  # filter out waterfall site that has no climate data
  filter(!is.na(overall_rank)) %>%
  filter(str_detect(crew_members, "newgraph_airvine|MateoW|tieasha.pierre")) %>%
  # filter out Stock Creek 195943 sites and duplicate 195944, keep Al's row that has the most info in it
  filter(!(pscis_crossing_id == 195943 & !str_detect(crew_members, "newgraph_airvine"))) %>%
  # filter out crossings that are not moti sites
  filter(!is.na(moti_chris_culvert_id)) %>%
  mutate(stream_name = case_when(pscis_crossing_id == 58067 ~ "Gramophone Creek", T ~ stream_name),
         stream_name = case_when(pscis_crossing_id == 123393 ~ "Lemieux Creek", T ~ stream_name)) %>%
  # have to add erosion to the condition rank, have to update every added rank field unfortunately (except priority rank)
  # can remove this chunk in future when math is updated in mergin form template
  mutate(condition_rank = erosion_issues + embankment_fill_issues + blockage_issues) %>%
  mutate(vulnerability_rank = condition_rank + climate_change_flood_risk) %>%
  mutate(overall_rank = vulnerability_rank + priority_rank)

names(moti_data_cleaned)
xref_moti_climate %>% pull(report)

# test to see the order is right - set_names seems risky perhaps... maybe its fine
# try <- tibble(
#   spdsht = names(moti_data_cleaned),
#   report = xref_moti_climate %>% pull(report)
# )

# all good


# burn to a csv to make changes in a reasonably quick manner.  Copy file and use it to read in
moti_data_cleaned %>%
  write_csv('data/inputs_extracted/tab_moti_prep_20230605.csv')

# read it back in cleaned up
moti_data_cleaned <- read_csv(file = 'data/inputs_raw/moti_climate_tidied_hand.csv')


# make table to insert into report
tab_moti <- moti_data_cleaned %>%
  purrr::set_names(nm = xref_moti_climate %>% pull(report)) %>%
  select(-my_crossing_reference)

tab_moti_phase2 <- moti_data_cleaned %>%
  filter(pscis_crossing_id %in% (pscis_phase2 %>% pull(pscis_crossing_id)))

