
<!-- README.pt-BR.md is generated from README.pt-BR.Rmd. Please edit that file -->

# bdffpRain

<!-- badges: start -->

[![R build
status](https://github.com/BrunaLab/BDFFP-precipitation/workflows/R-CMD-check/badge.svg)](https://github.com/BrunaLab/BDFFP-precipitation/actions)
[![DOI](https://zenodo.org/badge/271884316.svg)](https://zenodo.org/badge/latestdoi/271884316)

<!-- badges: end -->

*[English
Version](https://github.com/BrunaLab/BDFFP-precipitation/blob/master/README.md)*

Este repositório abriga o pacote `bdffpRain` e os dados brutos e código
de wrangling usados para produzir os conjuntos de dados`bdffp_rain`
(inglês) e `pdbff_chuva` (português).

## O pacote R

O pacote `bdffpRain` R contém dados limpos de precipitação diária de 8
medidores de chuva no Projeto de Dinâmica Biológica de Fragmentos
Florestais entre 1987 e 2010. Para instalar o pacote, execute:

``` r
install.packages("remotes")
remotes::install_github("BrunaLab/bdffpRain")
```

Os dados estão em `pdbff_chuva`, que se parece com isto:

``` r
library(bdffpRain)
data("pdbff_chuva")
head(pdbff_chuva)
#> # A tibble: 6 × 10
#>   local   lat   lon data         dia hora  observador chuva comentario flag 
#>   <chr> <dbl> <dbl> <date>     <dbl> <chr> <chr>      <dbl> <chr>      <chr>
#> 1 km37  -2.43 -59.8 2004-10-04   278 14:20 Rogerio     14   <NA>       <NA> 
#> 2 km37  -2.43 -59.8 2004-10-05   279 <NA>  <NA>        NA   <NA>       <NA> 
#> 3 km37  -2.43 -59.8 2004-10-06   280 07:30 Rogerio      2.6 <NA>       U    
#> 4 km37  -2.43 -59.8 2004-10-07   281 <NA>  <NA>        NA   <NA>       <NA> 
#> 5 km37  -2.43 -59.8 2004-10-08   282 12:30 Apostolo    36.8 <NA>       U    
#> 6 km37  -2.43 -59.8 2004-10-09   283 07:30 Rogerio     14.8 <NA>       <NA>
```

Verifique o arquivo de ajuda para metadados detalhados com
`?pdbff_chuva`.

## Dados brutos e código de wrangling

Se você estiver interessado nos dados brutos ou no código usado para
limpar e arrumar esses dados, você pode bifurcar este repositório ou
baixá-lo com o botão verde “Código” nesta página. Você encontrará os
dados brutos em uma série de arquivos .XLS no diretório `"data_raw"` e o
código de escrita anotado no diretório `"wrangling"`.

## Uso de dados

Caso sejam usados o pacote ou dados numa publicação, por favor cite:

``` r

"Scott, Eric R. & Emilio M. Bruna. 2022. BrunaLab/bdffpRain (v0.0.1). Zenodo. https://doi.org/10.5281/zenodo.6557721"
```

Em a referência em formato .bib:

``` r

@software{eric_r_scott_2022_6557721,
  author       = {Eric R Scott and
                  Emilio M. Bruna},
  title        = {BrunaLab/bdffpRain},
  month        = may,
  year         = 2022,
  publisher    = {Zenodo},
  version      = {v0.0.1},
  doi          = {10.5281/zenodo.6557721},
  url          = {https://doi.org/10.5281/zenodo.6557721},
}
```

A vinheta do pacote mostra um exemplo de como usar a imputação para
“preencher” as observações ausentes e produzir um conjunto de dados
completo que pode ser usado para produzir números e estatísticas
resumidas para a precipitação mensal no BDFFP.

Além disso, existe um código antigo, provavelmente quebrado, no
diretório `"notes"` que pode ser útil.

## Contribuindo

Se você encontrar erros ou problemas ou quiser sugerir melhorias,
registre um problema.
