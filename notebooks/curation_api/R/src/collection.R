library("httr")
library("rjson")
library("stringr")


url_builder <- function(path_segment) {
  api_url_base <- Sys.getenv("api_url_base")
  route_path <- str_interp("/curation/v1${path_segment}")
  print(str_interp("route path: ${route_path}"))
  url <- str_interp("${api_url_base}${route_path}")
  return(url)
}


get_headers <- function() {
  access_token <- Sys.getenv("access_token")
  return(add_headers(`Authorization` = str_interp("Bearer ${access_token}"), `Content-Type` = "application/json"))
}


create_collection <- function(collection_form_metadata) {
  url <- url_builder("/collections")
  res <- POST(
      url=collections_url, body=toJSON(collection_form_metadata),
      get_headers()
  )
  stop_for_status(res)
  res_content <- content(res)
  print("New private Collection uuid:")
  print(res_content$collection_uuid)
  print("New private Collection url:")
  print(str_interp("${site_url}/collections/${res_content$collection_uuid}"))
  return(res_content$collection_uuid)
}

