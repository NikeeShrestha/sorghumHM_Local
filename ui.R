library(shiny)

# Define UI for application that draws a histogram

### B73 genes
#b73genes_df <- read.delim("/home/liu3zhen/shiny/maizeHM/data/B73v5.genelist", header=F)
#colnames(b73genes_df) <- c("Gene")
#b73genes <- b73genes_df$Gene

#actionButton("action", "homomine")

### genome list
genomes_df <- read.delim("/home/ubuntu/mounteds3/sorghumHM_Local/data/genomelist", header=F)
genomes <- genomes_df[, 1]

shinyUI(fluidPage(
  
  #useShinyjs(),  # Set up shinyjs

  # Application title
  titlePanel("SorghumHM - search a BTX623 gene in another sorghum genome"),

  textOutput('introNote'),

  pageWithSidebar(
    #headerPanel('Search a B73 gene in another maize genome'),
	headerPanel(''),

    sidebarPanel(
	  textInput("gene", "BTX623 gene (e.g., Sobic.001G000100): ", value="Sobic"),
	  selectInput('genome', 'Target genome:', genomes, selected="BTX642.v.1.1"),
	  actionButton("go", "GO"),
	  width=2
	),
    
    mainPanel(
	  # Display error message
      uiOutput("errorMessage"),

      # Display running message
      uiOutput("runningMessage"),

	  #htmlOutput('waithtml'),
	  htmlOutput('html')

# 	  downloadButton("download", "Download"),
#       tableOutput("static")
    )
  )
))
