variable "emails" {
  default = [ "tomiamaooa@gmail.com", "txterror@live.co.uk"]
}

variable "myregion" {
  default = "us-east-1"
}

variable "accountId" {
}

variable "pet_frontend_content" {
    default = {
        "serverless.js" = ["modules/pet-reminder-app/serverless_frontend/serverless.js", "application/javascript"]
        "main.css" = ["modules/pet-reminder-app/serverless_frontend/main.css", "text/css"]
        "whiskers.png" = ["modules/pet-reminder-app/serverless_frontend/whiskers.png", "image/png"]
        "index.html" = ["modules/pet-reminder-app/serverless_frontend/index.html", "text/html"]
    }
  
}