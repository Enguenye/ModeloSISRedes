#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(plotly)
library(readxl)
library(markovchain)
library(fitdistrplus)
library(shiny)
library(shinydashboard)
library(igraph)
library(igraphdata)
source("Back.R")

# Define UI for application that draws a histogram
ui <- dashboardPage(
    
    dashboardHeader(title= "Reporte sobre los tiempos esperados de infección" ),
    dashboardSidebar( sidebarMenu(
        #con tabName se asigna un nombre a la tabla
        menuItem("Parametros", tabName = "FASI", icon = icon("th")),
        menuItem("Validación modelo", tabName = "FASII", icon = icon("th"))
    ) ),
    
    dashboardBody( tabItems(
        # Tabla de la accion de la fase I
        tabItem(tabName = "FASI",
                sidebarLayout(
                    sidebarPanel(
                        fileInput(inputId='ArchivoEntrada2', label='Cargue el archivo con la matriz de adyacencia del grafo',accept=c(".xlsx")),
                        sliderInput("tazaContagio",
                                    "Taza contagio",
                                    min = 0.1,
                                    max = 2,
                                    value = 1),
                        sliderInput("tazaRecuperacion",
                                    "Taza recuperación",
                                    min = 0.1,
                                    max = 2,
                                    value = 1),
                        sliderInput("horizonte",
                                    "Horizonte de tiempo a revisar",
                                    min = 3,
                                    max = 50,
                                    value = 6),
                        checkboxInput("show3", "Nodo crítico de la red", value = FALSE, width = NULL),
                        #panel condicional que se muestra o se escone dependiendo del valor de mi checkboxInput (arriba)
                        conditionalPanel("input.show3", verbatimTextOutput("nodoCritico"))
                        
                        ),
                    mainPanel(
                        box(title = "Grafo de la red",
                            plotOutput(outputId="Grafo"),width = 13),
                        box(title = "Tiempo esperado para que se termine la infección si se infecta el nodo x",
                            plotlyOutput(outputId="GraficaFaseI"),width = 13),
                        box(title = "Valor esperado en un instante dado el primer nodo infectado",
                            plotlyOutput(outputId="GraficaFase2"),width = 13),
                        box(title = "Valor esperado en un instante dado el primer nodo infectado",
                            plotlyOutput(outputId="GraficaFase3"),width = 13)
                       
                    )
                )
        ),
        tabItem(tabName = "FASII",
                sidebarLayout(
                    sidebarPanel(
                        fileInput(inputId='ArchivoEntrada3', label='Cargue el archivo con la matriz de adyacencia del grafo',accept=c(".xlsx")),
                        fileInput(inputId='ArchivoEntrada4', label='Cargue el archivo con el output de la simulación',accept=c(".xlsx")),
                        sliderInput("tazaContagio2",
                                    "Taza contagio",
                                    min = 0.1,
                                    max = 2,
                                    value = 1),
                        sliderInput("tazaRecuperacion2",
                                    "Taza recuperación",
                                    min = 0.1,
                                    max = 2,
                                    value = 1),
                        checkboxInput("show2", "Test de hipótesis de comparación(test de t-student)", value = FALSE, width = NULL),
                        #panel condicional que se muestra o se escone dependiendo del valor de mi checkboxInput (arriba)
                        conditionalPanel("input.show2", verbatimTextOutput("testChiSquared"))
                        
                    ),
                    mainPanel(
                        box(title = "Grafo que se está comparando",
                            plotOutput(outputId="Grafo2"),width = 13),
                        box(title = "Gráfica de la simulación",
                            plotlyOutput(outputId="GraficaComparativa"),width = 13),
                        box(title = "Gráfica del modelo de cadenas de Markov",
                            plotlyOutput(outputId="GraficaComparativa2"),width = 13),
                    )
                )
        )
        
    ) )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    

    datosMatriz <- eventReactive(input$ArchivoEntrada2, {
        Archivo2 <- input$ArchivoEntrada2
        if (is.null(Archivo2)) { return(NULL) }
        #se lee el archivo 
        dataFile2 <-read_excel(Archivo2$datapath)
        #se guarda unicamente la segunda columna que son las demandas
        Recuperacion<-dataFile2
    })
    
    datosMatriz2 <- eventReactive(input$ArchivoEntrada3, {
        Archivo2 <- input$ArchivoEntrada3
        if (is.null(Archivo2)) { return(NULL) }
        #se lee el archivo 
        dataFile2 <-read_excel(Archivo2$datapath)
        #se guarda unicamente la segunda columna que son las demandas
        Recuperacion<-dataFile2
    })
    
    datosMatriz3 <- eventReactive(input$ArchivoEntrada4, {
        Archivo2 <- input$ArchivoEntrada4
        if (is.null(Archivo2)) { return(NULL) }
        #se lee el archivo 
        dataFile2 <-read_excel(Archivo2$datapath)
        #se guarda unicamente la segunda columna que son las demandas
        Recuperacion<-dataFile2
    })
    
    

    
    output$GraficaFase2 <- renderPlotly({
        if (is.null(datosMatriz())) { return(NULL) }
        taza1<-input$tazaContagio
        taza2<-input$tazaRecuperacion
        cadena<-Crear_cadena_markov(datosMatriz(),taza1,taza2)
        valor<-input$horizonte
        graf<-serieDeTiempo(cadena,valor)
        plot_ly(z = graf, type = "heatmap")  %>%
            layout(
                xaxis = list(title = "Instante de tiempo"),
                yaxis = list (title = "Nodo infectado primero")) 
    })
    
    output$GraficaFase3 <- renderPlotly({
        if (is.null(datosMatriz())) { return(NULL) }
        taza1<-input$tazaContagio
        taza2<-input$tazaRecuperacion
        valor<-input$horizonte
        cadena<-Crear_cadena_markov(datosMatriz(),taza1,taza2)
        graf<-serieDeTiempo(cadena,valor)
        
        plot_ly(z = graf, type = "surface")  %>%
            layout(
                xaxis = list(title = "Instante de tiempo"),
                yaxis = list (title = "Nodo infectado primero")) 
    })
    
    output$GraficaFaseI <- renderPlotly({
        if (is.null(datosMatriz())) { return(NULL) }
        taza1<-input$tazaContagio
        taza2<-input$tazaRecuperacion
        valor<-input$horizonte
        cadena<-Crear_cadena_markov(datosMatriz(),taza1,taza2)
        graf<-tiempoEsperado(cadena)
        

        
        plot_ly( x = ~graf[[2]], y = ~graf[[3]], name = 'Tiempo esperado', type = 'bar')%>%
            layout(
                xaxis = list(title = "Primer nodo infectado"),
                yaxis = list (title = "Tiempo esperado para que se acabe la infección"))
        #Cerrar la funcion renderPlotly    
    })
    
    output$Grafo <- renderPlot({
        if (is.null(datosMatriz())) { return(NULL) }
        grafo=graph_from_adjacency_matrix(
            as.matrix(datosMatriz())
            )
        taza1<-input$tazaContagio
        taza2<-input$tazaRecuperacion
        valor<-input$horizonte
        cadena<-Crear_cadena_markov(datosMatriz(),taza1,taza2)
        graf<-serieDeTiempo(cadena,valor)
        nodo<-1
        max<-0
        
        for(j in c(1:length(graf[,1]))){
            if(graf[j,length(graf[1,])]>max){
                max=graf[j,length(graf[1,])]
                nodo=j
            }

        }
        V(grafo)[nodo]$color<-"red"
        plot( grafo)
    })
    
    output$Grafo2 <- renderPlot({
        if (is.null(datosMatriz2())) { return(NULL) }
        grafo=graph_from_adjacency_matrix(
            as.matrix(datosMatriz2()) 
        )
        
        
        plot( grafo)
        #Cerrar la funcion renderPlotly    
    })
    
    output$GraficaComparativa <- renderPlotly({
        if (is.null(datosMatriz3())) { return(NULL) }
        datosSimulacion<-t(as.matrix(datosMatriz3()))
        mapaCalor<-length(datosSimulacion[,1])*datosSimulacion

        plot_ly(z = mapaCalor, type = "heatmap")  %>%
            layout(
                xaxis = list(title = "Instante de tiempo"),
                yaxis = list (title = "Nodo infectado primero")) 
    })
    
    output$GraficaComparativa2<- renderPlotly({
        if (is.null(datosMatriz2())) { return(NULL) }
        taza1<-input$tazaContagio2
        taza2<-input$tazaRecuperacion2
        cadena<-Crear_cadena_markov(datosMatriz2(),taza1,taza2)
        graf<-serieDeTiempo2(cadena,10)
        
        plot_ly(z = graf, type = "heatmap")  %>%
            layout(
                xaxis = list(title = "Instante de tiempo"),
                yaxis = list (title = "Nodo infectado primero")) 
    })
    
    output$nodoCritico<-renderText({
        if (is.null(datosMatriz())) { return(NULL) }
        taza1<-input$tazaContagio
        taza2<-input$tazaRecuperacion
        valor<-input$horizonte
        cadena<-Crear_cadena_markov(datosMatriz(),taza1,taza2)
        graf<-serieDeTiempo(cadena,valor)
        nodo<-1
        max<-0
        print(graf)
        
        for(j in c(1:length(graf[,1]))){
            if(graf[j,length(graf[1,])]>max){
                max=graf[j,length(graf[1,])]
                nodo=j
            }
            print(nodo)
        }
        sprintf("El nodo crítico de la red es el: %f" ,nodo)
    })
    
    output$testChiSquared<- renderText({
        if (is.null(datosMatriz3()) || is.null(datosMatriz2()) ) { return(NULL) }
        datosSimulacion<-t(as.matrix(datosMatriz3()))
        mapaCalor<-length(datosSimulacion[,1])*datosSimulacion
        taza1<-input$tazaContagio2
        taza2<-input$tazaRecuperacion2
        cadena<-Crear_cadena_markov(datosMatriz2(),taza1,taza2)
        graf<-serieDeTiempo2(cadena,10)
        vec1<-c(graf)
        vec2<-c(mapaCalor)
        respuesta=""
        r<-t.test(vec1,vec2)
        if (r$p.value>0.05){
            sprintf("El valor del p-value es :%f por lo que las dos muestras no son similares.",r$p.value)
        }
        else{
            sprintf("El valor del p-value es :%f por lo que las dos muestras si son similares.",r$p.value)
        }
    })
    


}

# Run the application 
shinyApp(ui = ui, server = server)
