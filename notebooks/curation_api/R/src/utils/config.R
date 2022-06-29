library("stringr")
library("readr")


set_api_urls <- function(env = "prod") {
  if (env == "prod") {
    domain_name <- "cellxgene.cziscience.com"
  } else if (env == "dev" || env == "staging") {
    domain_name <- str_interp("cellxgene.${env}.single-cell.czi.technology")
  }
  Sys.setenv(
    "site_url" = str_interp("https://${domain_name}"),
    "api_url_base" = str_interp("https://api.${domain_name}")
  )
  print("Set 'site_url' env var to ${Sys.getenv('site_url')}")
  print("Set 'api_url_base' env var to ${Sys.getenv('api_url_base')}")
}


set_access_token <- function(api_key_file_path) {
  api_key <- read_file(api_key_file_path)
  access_token_path <- "/curation/v1/auth/token"

  api_url_base <- Sys.getenv("api_url_base")
  access_token_url <- str_interp("${api_url_base}${access_token_path}")

  res <- POST(url=access_token_url, add_headers(`x-api-key`=api_key))
  stop_for_status(res)
  access_token <- content(res)$access_token
  
  Sys.setenv("access_token" = access_token)
  print("Successfully set 'access_token' env var!")
}

