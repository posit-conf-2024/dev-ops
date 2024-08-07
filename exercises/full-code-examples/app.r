library(shiny)
library(httr2)

# Correct API URL
api_url <- "https://granite-mole.fd049.fleeting.rstd.io/rsconnect/content/e444fd65-634f-4b6a-bc78-be70c790cc3f/predict"

ui <- fluidPage(
  titlePanel("Penguin Mass Predictor"),
  
  # Model input values
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "bill_length",
        "Bill Length (mm)",
        min = 30,
        max = 60,
        value = 45,
        step = 0.1
      ),
      selectInput(
        "sex",
        "Sex",
        c("male", "female") # Ensure values match what FastAPI expects
      ),
      selectInput(
        "species",
        "Species",
        c("Adelie", "Chinstrap", "Gentoo")
      ),
      # Get model predictions
      actionButton(
        "predict",
        "Predict"
      )
    ),
    
    mainPanel(
      h2("Penguin Parameters"),
      verbatimTextOutput("vals"),
      h2("Predicted Penguin Mass (g)"),
      textOutput("pred")
    )
  )
)

server <- function(input, output) {
  # Input params
  vals <- reactive(
    list(
      bill_length_mm = input$bill_length,
      species = input$species, # Send the species directly
      sex = tolower(input$sex) # Ensure "male" and "female" are lowercase
    )
  )
  
  # Fetch prediction from API
  pred <- eventReactive(
    input$predict,
    {
      req <- httr2::request(api_url) |>
        httr2::req_body_json(vals()) |>
        httr2::req_headers(
          "Content-Type" = "application/json",
          "Authorization" = paste("Bearer", Sys.getenv("key")) # Add API key to headers
        ) |>
        httr2::req_perform()
      
      httr2::resp_body_json(req)
    },
    ignoreInit = TRUE
  )
  
  
  # Render to UI
  output$pred <- renderText(pred()$body_mass_g)
  output$vals <- renderPrint(vals())
}

# Run the application
shinyApp(ui = ui, server = server)
