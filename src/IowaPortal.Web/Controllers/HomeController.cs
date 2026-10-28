using Microsoft.AspNetCore.Mvc;

namespace IowaPortal.Web.Controllers;

public sealed class HomeController : Controller
{
    public IActionResult Index() => View();

    public IActionResult DesignSystem() => View();

    public IActionResult UiUx() => View();

    public IActionResult Accessibility() => View();

    public IActionResult CodeSamples() => View();

    public IActionResult Error(string? correlationId)
    {
        ViewBag.CorrelationId = correlationId;
        return View();
    }
}
