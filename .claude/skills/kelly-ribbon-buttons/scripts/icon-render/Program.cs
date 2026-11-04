// Local helper: serves SVG masters to a render page and saves the PNGs the page posts back.
var root = args.Length > 0 ? args[0] : Directory.GetCurrentDirectory();
var svgDir = Path.Combine(root, "svg");
var pngDir = Path.Combine(root, "png");
var app = WebApplication.CreateBuilder(args).Build();
app.UseDefaultFiles(new DefaultFilesOptions { FileProvider = new Microsoft.Extensions.FileProviders.PhysicalFileProvider(Path.Combine(root, "wwwroot")) });
app.UseStaticFiles(new StaticFileOptions { FileProvider = new Microsoft.Extensions.FileProviders.PhysicalFileProvider(Path.Combine(root, "wwwroot")) });
app.MapGet("/list", () => Directory.GetFiles(svgDir, "*.svg").Select(Path.GetFileName).OrderBy(n => n));
app.MapGet("/svg/{name}", (string name) => Results.File(Path.Combine(svgDir, Path.GetFileName(name)), "image/svg+xml"));
app.MapPost("/save/{name}", async (string name, HttpRequest request) =>
{
    Directory.CreateDirectory(pngDir);
    var path = Path.Combine(pngDir, Path.GetFileName(name));
    await using var file = File.Create(path);
    await request.Body.CopyToAsync(file);
    return Results.Ok(path);
});
app.Run("http://localhost:5317");
