library(curl)
library(RCurl)
library(rio)
library(dygraphs)
library(rlist)


graficar_firmas <<- function(id, summarize = TRUE) 
{
  ## CREAR LISTA DE ARCHIVOS PARA LEER
  ## CREA NOMBRE DE ARCHIVOS CON 5 DIGITOS (0´S A LA IZQUIERDA) SEGUN EL "id"
  filename <- paste("https://raw.githubusercontent.com/cheespanther/analisis_firmas_PR_centrogeo/master/datos/ref",sprintf("%05d", id), ".asd",".txt", sep="")
  ## LEE ARCHIVOS SEGUN EL "id" Y EL DIRECTORIO DONDE SE ENCUENTREN
  datos <- lapply(paste(filename), read.delim, header=TRUE)
  
  datos_tabla <- list.cbind(datos)
  longitud <- datos_tabla$Wavelength
  
  columna_seleccion <- paste("ref",sprintf("%05d", id), ".asd", sep="")
  
  dt <- datos_tabla[ , columna_seleccion]
  dt <- as.data.frame(cbind(longitud, dt))
  
  print.data.frame(dt)

  p <- dygraph(dt) %>%
    dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = TRUE) %>%
    dyRangeSelector() %>%
    dyCrosshair(direction = "vertical") %>%
    dyHighlight(highlightCircleSize = 5, highlightSeriesBackgroundAlpha = 0.2, hideOnMouseOut = FALSE)  %>%
    dyRoller(rollPeriod = 1) %>%
    dyAxis("x", label = "Longitud de onda") %>%
    dyAxis("y", label = "Valor")
  
  return(p)
}
