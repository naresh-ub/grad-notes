# scripts/trigger_binder.py

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time

def main():
    # Set up Chrome options to run in headless mode
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")

    # Launch Chrome WebDriver
    driver = webdriver.Chrome(options=chrome_options)

    try:
        # Replace this with your actual website URL
        website_url = 'https://naresh-ub.github.io/grad-notes/'
        print(f'Navigating to {website_url}')
        driver.get(website_url)

        # Wait for the page to load completely
        time.sleep(3)

        # Execute the JavaScript function directly
        print('Executing the initThebeSBT function')
        driver.execute_script('initThebeSBT();')

        # Optionally wait for the process to finish
        time.sleep(5)

        print('Binder triggered successfully.')

    except Exception as e:
        print(f'Error occurred: {e}')
        exit(1)

    finally:
        driver.quit()

if __name__ == '__main__':
    main()
