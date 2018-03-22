| *Setting*     | *Value*               |
| Library       | SeleniumLibrary       |
| Library       | XvfbRobot             |

| *Test Case*   | *Action*              | *Argument*                    |
| Visit site    | Start Virtual Display | 1920                          | 1080
|               | Open Browser          | http://192.168.1.75:9090      |
|               | Set Window Size       | 1920                          | 1080
|               | ${HELLO_TEXT}=        | Get Text                      | xpath=//pre
|               | log                   | The text is ${HELLO_TEXT}     |
|               | Should Be Equal As Strings | ${HELLO_TEXT}            | Hello world version 6!
|               | [Teardown]            | Close Browser                 |

