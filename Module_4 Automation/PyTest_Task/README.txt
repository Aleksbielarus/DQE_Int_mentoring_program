To run testing and generation jsons for allure report use this command:
pytest -s -v ./tests/test_case.py --alluredir=allureress   

To generate test report use this command:
allure generate allureress

You can find Allure report in the Allure-report -> index.html
