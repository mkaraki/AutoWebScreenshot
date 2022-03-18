using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System.Reflection;


var service = ChromeDriverService.CreateDefaultService();
service.LogPath = "chromedriver.log";
service.EnableVerboseLogging = true;

ChromeOptions options = new ChromeOptions();
options.AddArgument("headless");
options.AddArgument("window-size=1920x1920");

if ((Environment.GetEnvironmentVariable("NO_SANDBOX") ?? "0") == "1")
    options.AddArgument("no-sandbox");

using (var driver = new ChromeDriver(service, options))
{
    driver.Url = args[0];

    await Task.Delay(10000);

    var screenshot = (driver as ITakesScreenshot).GetScreenshot();

    screenshot.SaveAsFile(args[1]);
}