#' @title Process Data
#' @description Process input data frame of clc or hbpc data
#' @param df dataframe of CLC or HBPC data
#' @param envir Environment with constants for processing df.
#' @return list of dataframes: rate and category data frames.
#' @import dplyr
#' @importFrom lubridate make_date 
process_data <- function(df, envir){
  cat(paste("\n\n--- Processing", environmentName(envir), "Data\n"))
  # Check for valid inputs
  valid_input <- check_input(df, envir$COL_NAMES)
  
  if(!valid_input){
    print("Aborting: Problem with input data.\n")
    return(list())
  }
  
  # Special processing input
  if(environmentName(envir) == 'hbpc'){
    df_filtered <- filter_hbpc_data(df)
  }
  
  if(environmentName(envir) == 'clc'){
    df_filtered <- filter_clc_data(df) 
  }
  
  if(environmentName(envir) == 'dementia'){
    df_filtered <- filter_dementia_data(df) 
  }
  
  rate_df <- calc_rate_sums(df_filtered, envir$ID_COLS, envir$NUMER_COLS, envir$DENOM_COLS, envir$GROUP_COLS)
  category_df <- calc_category_sums(df_filtered, envir$ID_COLS, envir$CATEGORIES, envir$GROUP_COLS)
  
  return(list(rate=rate_df, category=category_df))
}
