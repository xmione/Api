using Microsoft.OpenApi.Models;

ILogger _logger;
ILoggerFactory _loggerFactory;

var builder = WebApplication.CreateBuilder(args);

_loggerFactory = LoggerFactory.Create(builder => builder.AddConsole());
_logger = _loggerFactory.CreateLogger<Program>();

var _environment = builder.Environment;
var _environmentName = _environment.EnvironmentName;
var _isDevelopment = _environment.IsDevelopment();

_logger.LogInformation("Start processing API");
_logger.LogInformation($"_environmentName {_environmentName}");
_logger.LogInformation($"_isDevelopment {_isDevelopment}");

// Add services to the container.

builder.Services.AddCors(c =>
{
    c.AddPolicy("AllowOrigin", options => options.AllowAnyOrigin()
    .AllowAnyMethod()
    .AllowAnyHeader());
});

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    _logger.LogInformation("Adding SwaggerDoc");
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Accsol.API", Version = "v1" });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
//if (app.Environment.IsDevelopment())
//{
//    app.UseSwagger();
//    app.UseSwaggerUI();
//}

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    _logger.LogInformation("Adding swagger endpoint.");
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "AccSol Accounting Solution V1");
});

app.UseHttpsRedirection();

app.UseCors(options => options.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());

app.UseAuthorization();

app.MapControllers();

app.Run();
