\name{electoral_division}
\alias{electoral_division}
\docType{data}
\title{
Official electoral divisions
}
\description{
Dataset with official electoral division that groups communes to vote for
senators and deputies. This dataset considers communes names so that you can
use \code{new_territorial_codes} or \code{new_territorial_codes} to group by
region or province. This division is valid from 2018 to 2021 according to the
chilean law.
}
\usage{electoral_division}
\format{
Data frame

> str(electoral_division)
Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	346 obs. of  5 variables:
 $ commune_id              : chr  "15101" "15102" "15202" "15201" ...
 $ circumscription_id      : chr  "01" "01" "01" "01" ...
 $ circumscription_senators: int  2 2 2 2 2 2 2 2 2 2 ...
 $ district_id             : chr  "01" "01" "01" "01" ...
 $ district_deputies       : int  3 3 3 3 3 3 3 3 3 3 ...
}
\source{
Subsecretaria de Desarrollo Regional (SUBDERE) and Biblioteca del Congreso
Nacional de Chile
}
\keyword{datasets}
