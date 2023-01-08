*** Settings ***
Suite Setup       Open Browser    ${url}    ${browser}    # Test Suite precondition: Browser SetUp
Library           SeleniumLibrary
Library           String
Library           Collections

*** Variables ***
${url}            https://academybugs.com/find-bugs/
${browser}        chrome
${first_product_lowest_price}    True
${Madel Number}    \







*** Test Cases ***
TestCase_1_Check_the_Price_on_the_Product_Listing_Page
    [Documentation]    Task in Robot Framework
    Log    Test case on ECommerce
    ${Price1} =    Get Text    xpath://section//ul//li[1]//div//div[3]//div[1]//span
    ${Price1} =    Get Substring    ${Price1}    1
    Click Element    xpath://section//li[1]//div//div[1]//a
    Wait Until Element Is Visible    xpath://input[@value="ADD TO CART"]
    ${Price2} =    Get Text    xpath://main//article//section//div[2]//span
    ${Price2} =    Get Substring    ${Price2}    1
    Log    "Price 1: " ${Price1}
    Log    "Price 2: " ${Price2}
    Should Be Equal    ${Price1}    ${Price2}    "Product prices are not same"

TestCase_2_Verify_that_the_first_product_price_is_the_lowest
    Go To    https://academybugs.com/find-bugs/
    Select From List By Value    id:sortfield    1
    @{product_prices}    Get Webelements    xpath://span[@class="ec_price_type1"]
    ${price1}=    Get From List    ${product_prices}    0
    ${price1}=    Get Text    ${price1}
    ${price1}=    Get Substring    ${price1}    1
    FOR    ${individual_item}    IN    @{product_prices}
        ${individual_price}    Get Text    ${individual_item}
        ${individual_price}    Get Substring    ${individual_price}    1
        IF    ${price1} > ${individual_price}
            Set Test Variable    ${first_product_lowest_price}    ${False}
        END
    END
    IF    ${first_product_lowest_price}
        Log    "The first product has the lowest value."
    ELSE
        Log    "The first product is not the lowest."
    END

TestCase_3_Get_the_model_number_and_assign_it_to_the_suite_variable
    Go To    https://academybugs.com/store/professional-suit/
    Wait Until Element Is Visible    xpath://div[@class="ec_details_model_number"]
    ${model} =    Get Text    xpath://div[@class="ec_details_model_number"]
    ${model} =    Get Substring    ${model}    14
    Set Suite Variable    ${Madel Number}    ${model}
    Log    Madel Number: ${Madel Number}

TestCase_4_Check_that_the_respective_product_is_displayed_on_the_search_page
    Go To    https://academybugs.com/store/professional-suit/
    Clear Element Text    xpath://input[@class="ec_search_input"]
    Log    Madel Nummber: ${Madel Number}
    Input Text    xpath://input[@class="ec_search_input"]    ${Madel Number}
    Click Element    xpath://input[@value="Search"]
    Wait Until Element Is Visible    xpath://main//div[3]//div[2]//span//a
    Click Element    xpath://main//div[3]//div[2]//span//a
    Wait Until Element Is Visible    xpath://div[@class="ec_details_model_number"]
    ${model2} =    Get Text    xpath://div[@class="ec_details_model_number"]
    ${model2} =    Get Substring    ${model2}    14
    IF    ${Madel Number} == ${model2}
        Log    The searched product ${Madel Number} is displayed on the search page.
    ELSE
        Log    The searched product ${Madel Number} is not displayed on the search page.
    END
