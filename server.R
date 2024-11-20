### maizeHM

library(shiny)

data <- read.delim("data/BTX623.genelist", header=F)
colnames(data) <- c("Gene")

### function to output html
getPage <- function(htmlfile) {
  return(includeHTML(htmlfile))
}

shinyServer(function(input, output, session) {
  # Introductory note
  output$introNote <- renderText("The module homomine from Package Homotools is implemented to search a BTX623 gene in another sorghum genome. The service is provided by Liu lab at Kansas State University. Contact Sanzhen Liu(liu3zhen@ksu.edu) if you have a question.")
  
  # Standard variable to store folder path
  foldertoremove <- NULL
  
  # Display error message
  output$errorMessage <- renderUI({
    gene_DB_count <- sum(data$Gene %in% input$gene)
    if (gene_DB_count > 0) {
      return(NULL)  # No error, return NULL
    } else if (input$gene == "Sobic.001G") {
      return(tags$div(
        class = "alert alert-info",
        "Please enter a valid gene ID in the left textbox"
      ))
    } else {
      return(tags$div(
        class = "alert alert-danger",
        paste(input$gene, "is not in the BTX623.V5 gene list.")
      ))
    }
  })
  
  # Display running message
  jobStatus <- reactiveValues(running = FALSE) 
  output$runningMessage <- renderUI({
    if (jobStatus$running) {
      return(tags$div(
        class = "alert alert-info",
        "Report the result"
      ))
    } else {
      return(NULL)
    }
  })
  
  observeEvent(input$go, {
    jobStatus$running <- TRUE
    
    # Perform analysis
    system(paste("bash scripts/1m_B73v5_homomine.sh", input$gene, input$genome))  # Run homomine
    
    # Construct output paths
    htmlout <- paste0("Output/", input$genome, "/", input$gene, "/", input$gene, ".homomine.report.html")
    foldertoremove <<- paste0("Output/", input$genome, "/", input$gene)  # Store folder path in global variable
    
    # Display HTML output
    if (file.exists(htmlout)) {
      output$html <- renderUI({ getPage(htmlout) })
    } else {
      output$errorMessage <- renderUI({
        tags$div(class = "alert alert-danger", "Result file not found.")
      })
    }
    
    jobStatus$running <- FALSE
  })
  
  # Cleanup folder on session end
  session$onSessionEnded(function() {
    if (!is.null(foldertoremove) && dir.exists(foldertoremove)) {
      unlink(foldertoremove, recursive = TRUE, force = TRUE)
      cat("Folder removed:", foldertoremove, "\n")
    } else {
      cat("No folder to remove or folder does not exist.\n")
    }
  })
})












