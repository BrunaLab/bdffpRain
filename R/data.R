#' Rain gauge data from Biological Dynamics of Forest Fragments Project (BDFFP)
#'
#' Precipitation data from the Biological Dynamics of Forest Fragments Project.
#' Data was collected by rain gauge manually recorded by observers.  When a site
#' wasn't visited for some time, measurements were noted as accumulated.  There
#' are also gaps in the data when sites weren't visited for longer periods of
#' time.
#' @import tibble
#' @format a tibble with 42552 rows and 10 variables:
#' \describe{
#'  \item{site}{site name}
#'  \item{lat}{approximate lattitude of rain gauge}
#'  \item{lon}{approximate longitude of rain gauge}
#'  \item{date}{date of observation}
#'  \item{doy}{day of year}
#'  \item{time}{time of observation in 24 hr time}
#'  \item{observer}{observer name}
#'  \item{precip}{recorded precipitation in mm}
#'  \item{notes}{consolidated notes from field notes column in raw data sheets
#'  as well as text comments made in the time column in the original data}
#'  \item{flag}{Multi-day accumulations noted in raw data (A), observations
#'  following missing data points (assumed multi-day accumulations, U), data
#'  error (E), trace precipitation (T)}
#' }
#' @note The `observer` column contains many duplicates due to typos,
#'   alternative spellings of names, and inconsistent use of nicknames (e.g. Zé
#'   is a nickname used by both José Luis and José Paulo, all of which also
#'   appear with an unaccented "e").
"bdffp_rain"




#' Dados do pluviômetro do Projeto Dinâmica Biológica de Fragmentos Florestais (PDBFF)
#'
#' Dados de precipitação do Projeto Dinâmica Biológica de Fragmentos Florestais.
#' Os dados foram coletados por pluviômetro manualmente registrados por
#' observadores. Quando um local não era visitado por algum tempo, as medições
#' eram anotadas como acumuladas. Também existem lacunas nos dados quando os
#' sites não foram visitados por longos períodos de tempo.
#' @import tibble
#' @format um tibble com 42552 linhas e 10 variáveis:
#' \describe{
#'  \item{local}{nome do site}
#'  \item{lat}{latitude aproximada do pluviômetro}
#'  \item{lon}{longitude aproximada do pluviômetro}
#'  \item{data}{data de observação}
#'  \item{dia}{dia do ano}
#'  \item{hora}{tempo de observação em 24 horas}
#'  \item{observador}{nome do observador}
#'  \item{chuva}{precipitação registrada em mm}
#'  \item{comentario}{notas consolidadas da coluna de notas de campo em
#'  planilhas de dados brutos, bem como comentários de texto feitos na coluna de
#'  tempo nos dados originais}
#'  \item{flag}{Acumulações de vários dias observadas em dados brutos (A),
#'  observações após pontos de dados ausentes (acumulações de vários dias
#'  assumidas, U), erro de dados (E), precipitação de rastreamento (T)}
#' }
#' @note A coluna do `observador` contém muitas duplicatas devido a erros de
#'   digitação, grafia alternativa de nomes e uso inconsistente de apelidos (por
#'   exemplo, Zé é um apelido usado por José Luis e José Paulo, todos os quais
#'   também aparecem com um "e" sem acento).
"pdbff_chuva"
