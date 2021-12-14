*** Settings ***
Documentation       Orders robots from RobotSpareBin Industries Inc.
...                 Saves the order HTML receipt as a PDF file.
...                 Saves the screenshot of the ordered robot.
...                 Embeds the screenshot of the robot to the PDF receipt.
...                 Creates ZIP archieve of the receipts and the images.

*** Settings ***
Library    RPA.Browser.Selenium
Library    RPA.HTTP
Library    RPA.Tables
Library    RPA.PDF
Library    RPA.Archive
Library    RPA.Dialogs
Library    RPA.Robocorp.Vault
Library    OperatingSystem

*** Variables ***
${consent_button}    //div[@class="alert-buttons"]/button
${img_folder}    ${CURDIR}${/}image_files

*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Prepare the process directories
    ${order_site}    Get address from vault
    Open the RobotSpareBin website    ${order_site}
    ${orders_location}    Get orders address
    Download orders from csv file    ${orders_location}
    ${orders}    Get orders from file
    Fill and enter orders    ${orders}
    Zip receipts    ${OUTPUT_DIR}${/}    ${OUTPUT_DIR}${/}
    [Teardown]    Close Browser

*** Keywords ***
Prepare the process directories
    Create Directory    ${img_folder}
    Empty Directory    ${img_folder}
    Remove Files    ${OUTPUT_DIR}${/}*.pdf    missing_ok=${TRUE}
    Remove Files    ${OUTPUT_DIR}${/}*.zip    missing_ok=${TRUE}

Get address from vault
    ${secret}    Get Secret    mysecrets
    [Return]    ${secret}[robot-order-site]

Open the RobotSpareBin website
    [Arguments]    ${site}
    Open Available Browser    ${site}
    Give consent

Give consent
    Wait Until Element Is Visible    class:alert-buttons
    Click Button    ${consent_button}

Download orders from csv file
    [Arguments]    ${address}
    Download    ${address}    overwrite=${TRUE}

Get orders from file
    ${table}    Read table from CSV    orders.csv
    [Return]    ${table}

Fill and enter orders
    [Arguments]    ${orders}
    Wait Until Element Is Visible    //div[@class="stacked"]
    FOR    ${order}    IN    @{orders}
        Select From List By Value    head    ${order}[Head]
        Click Element    id-body-${order}[Body]
        Input Text    //input[@placeholder="Enter the part number for the legs"]
        ...           ${order}[Legs]
        Input Text    address    ${order}[Address]
        Preview order and save image    ${order}[Order number]
        Submit order    ${order}[Order number]
    END

Preview order and save image
    [Arguments]    ${robot_id}
    Click Button    preview
    Wait Until Element Is Visible    //img[@alt="Legs"]
    Screenshot    id:robot-preview-image
    ...           ${img_folder}${/}robot-image${robot_id}.PNG

Submit order
    [Arguments]    ${order_number}
    Click Button    order
    ${success}    Is Element Visible   receipt
    IF    ${success}
        Export receipt as PDF    ${order_number}
        Click Button    order-another
        Give consent
    ELSE
        Submit order    ${order_number}
    END

Export receipt as PDF
    [Arguments]    ${order_number}
    ${receipt}    Get Element Attribute    id:receipt    outerHTML
    Html To Pdf    ${receipt}    ${OUTPUT_DIR}${/}order-number-${order_number}.pdf
    Open Pdf    ${OUTPUT_DIR}${/}order-number-${order_number}.pdf
    ${files}    Create List    ${img_folder}${/}robot-image${order_number}.PNG
    Add Files To Pdf    ${files}
    ...                 ${OUTPUT_DIR}${/}order-number-${order_number}.pdf
    ...                 ${TRUE}
    Close Pdf    ${OUTPUT_DIR}${/}order-number-${order_number}.pdf

Zip receipts
    [Arguments]    ${source_folder}    ${destination_folder}
    Archive Folder With Zip    ${source_folder}
    ...                        ${destination_folder}receipt-pdf-archive.zip
    ...                        recursive=${TRUE}    include=*.pdf

Get orders address
    Add Heading    Hey, let's get ordering those robots!
    Add text input    orders_address
    ...               label=Where can we find the order list?
    ...               placeholder=Enter orders.csv address
    ${result}    Run Dialog
    [Return]    ${result.orders_address}
    