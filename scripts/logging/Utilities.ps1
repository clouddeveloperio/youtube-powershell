. .\logging.ps1

function TestFunction($message){  
     LogToFile -message "Message from another function: $message"
}

function AnotherFunction(){
    TestFunction -message "Another Function"
}