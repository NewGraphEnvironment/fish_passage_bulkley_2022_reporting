# extract moti climate change data from mergin field form and make table to insert into reporting

source('scripts/packages.R')
source('scripts/tables.R')

# read csv that has column names we want
xref_moti_climate <- read_csv(file = 'data/inputs_raw/xref_moti_climate.csv')

# read in data from mergin form, contains all skeena data as well so need to filter out bulk sites
moti_site_data <- read_csv(file = 'data/dff/form_pscis_moti_20230511.csv') %>%
  rename(moti_chris_culvert_id = chris_culvert_id) %>%
  select(any_of(xref_moti_climate %>% pull(spdsht))) %>%
  # pull out sites that match pscis ids or my crossing references from bulk repo object
  filter(pscis_crossing_id %in% (pscis_all %>% pull(pscis_crossing_id))|
        !is.na(my_crossing_reference) &
        my_crossing_reference %in% (pscis_all %>% pull(my_crossing_reference))) %>%
  arrange(pscis_crossing_id)

# some pscis ids and crossing references were input wrong in mergin form, see which sites are missing by comparing to bulkley repo pscis object

# see_diff <- pscis_all %>%
#   filter(!pscis_crossing_id %in% (moti_site_data %>% pull(pscis_crossing_id))&
#            !my_crossing_reference %in% (moti_site_data %>% pull(my_crossing_reference)))
# none of them are culverts, so they don't have climate data

# filter out sites that don't have overall climate ranks, filter out duplicate sites that were not done by Mateo or AI (keep Tieasha's Perow site)
moti_data_cleaned <- moti_site_data %>%
  filter(!is.na(overall_rank)) %>%
  filter(str_detect(crew_members, "newgraph_airvine|MateoW|tieasha.pierre|AI")) %>%
  # filter out Stock Creek 195943 sites, keep Al's row that has the most info in it
  filter(!(pscis_crossing_id == 195943 & !str_detect(crew_members, "newgraph_airvine")))


# make table to insert into report
tab_moti <- moti_data_cleaned %>%
  purrr::set_names(nm = xref_moti_climate %>% pull(report)) %>%
  mutate(pscis_crossing_id = case_when(my_crossing_reference == 2022091001 ~ 198115, T ~ pscis_crossing_id)) %>%
  select(-my_crossing_reference)

