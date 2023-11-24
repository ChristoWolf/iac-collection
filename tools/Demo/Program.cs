using System;
using System.Diagnostics;
using System.Text.RegularExpressions;
using OpenQA.Selenium.Appium;
using OpenQA.Selenium.Appium.Windows;

var process = Process.Start(@"C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe");
var options = new AppiumOptions();
options.AddAdditionalCapability("platformName", "Windows");
options.AddAdditionalCapability("platformVersion", "10");
options.AddAdditionalCapability("deviceName", "WindowsPC");
options.AddAdditionalCapability("ms:waitForAppLaunch", 30);
// See https://github.com/microsoft/WinAppDriver/blob/master/Samples/C%23/CalculatorTest/CalculatorSession.cs.
options.AddAdditionalCapability("app", "Microsoft.WindowsCalculator_8wekyb3d8bbwe!App");
var driver = new WindowsDriver<WindowsElement>(new Uri("http://127.0.0.1:4723/"), options, TimeSpan.FromMinutes(1));
var calc = driver.FindElementByName("Calculator");
var buttonOne = calc.FindElementByAccessibilityId("num1Button");
var buttonPlus = calc.FindElementByAccessibilityId("plusButton");
var buttonEquals = calc.FindElementByAccessibilityId("equalButton");
var resultDisplay = calc.FindElementByAccessibilityId("CalculatorResults");
buttonOne.Click();
buttonPlus.Click();
buttonOne.Click();
buttonEquals.Click();
var result = Regex.Match(resultDisplay.Text, @"\d+").Value;
Console.WriteLine($"1 + 1 = {result}");
driver.Quit();
process.Kill();
