*** Settings ***
Library       ../modules/APICalls.py
Library       ../modules/AccountPayloadGenerator.py

*** Test Cases ***
Account update using api for open caption set as True
    [Tags]             CDP   AccountSync   Regression
    [Documentation]      Account update from Salesforce to CDP: This rest call sets the account setting of a particular clinic as open caption setting True

    ${set_account_OC_ON} =           Set_Account OC ON and_return Status Code
    ${open_caption_setting} =        Get Account Open Caption Setting
    Log                              ${open_caption_setting}
    Should Be Equal As Integers      ${set_account_OC_ON}       201
    Should Be True                   ${open_caption_setting} == True


Account update using api for open caption set as False
    [Tags]               CDP   AccountSync   Regression
    [Documentation]      Account update from Salesforce to CDP: This rest call sets the account setting of a particular clinic as open caption setting False

    ${set_account_OC_OFF} =           Set Account OC OFF and return Status Code
    ${open_caption_setting} =         Get Account Open Caption Setting
    Log                               ${open_caption_setting}
    Should Be Equal As Integers       ${set_account_OC_OFF}      201
    Should Be True                    ${open_caption_setting} == False

*** Keywords ***
Init
    Set Log Level      DEBUG
