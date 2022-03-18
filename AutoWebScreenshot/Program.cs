using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System.Reflection;

if (!Directory.Exists("output"))
{ 
    Directory.CreateDirectory("output");
}

ChromeOptions options = new ChromeOptions();
options.AddArgument("headless");
options.AddArgument("window-size=1920x1920");
using (var driver = new ChromeDriver(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), options))
{
    driver.Url = args[0];

    await Task.Delay(10000);

    var screenshot = (driver as ITakesScreenshot).GetScreenshot();

    var outpath = Path.Combine("output", args[1]);
    screenshot.SaveAsFile(outpath);
}