using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

namespace Api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {

        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly ILogger<WeatherForecastController> _logger;

        public WeatherForecastController(ILogger<WeatherForecastController> logger)
        {
            _logger = logger;
           
        }

        [HttpGet(Name = "GetWeatherForecast")]
        public IEnumerable<WeatherForecast> Get()
        {
            return Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                TemperatureC = Random.Shared.Next(-20, 55),
                Summary = Summaries[Random.Shared.Next(Summaries.Length)]
            })
            .ToArray();
        }

        [HttpGet("TestDatabaseConnection")]
        public IActionResult TestDatabaseConnection(string serverName = "localhost,14344", string databaseName = "master", string userId = "sa", string password = "P@ssw0rd123")
        {

            string connectionString = $"Server={serverName};Database={databaseName};User Id={userId};Password={password};";
            string queryString = "SELECT TOP 1 * FROM sys.databases;";

            _logger.LogInformation("Connection String: {0}", connectionString);
            _logger.LogInformation("Query String: {0}", queryString);

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    _logger.LogInformation("Create new SqlCommand");
                    using (var command = new SqlCommand(queryString, connection)) 
                    {
                        try
                        {
                            CultureInfo.CurrentCulture = CultureInfo.InvariantCulture;
                            CultureInfo.CurrentUICulture = CultureInfo.InvariantCulture;
                            _logger.LogInformation("Open connection");
                            connection.Open();

                            // Add a simple query execution here
                            using (SqlCommand versionCommand = new SqlCommand("SELECT @@VERSION", connection)) 
                            {
                                string version = (string)versionCommand.ExecuteScalar();
                                _logger.LogInformation("SQL Server Version: {0}", version);

                            }

                            _logger.LogInformation("Execute reader");
                            using (SqlDataReader reader = command.ExecuteReader()) 
                            {
                                _logger.LogInformation("Read");
                                while (reader.Read())
                                {
                                    Console.WriteLine(String.Format("{0}", reader[0]));
                                }
                                _logger.LogInformation("Close connection");

                                reader.Close();
                            }


                            return Ok("Database Connection Successful");
                        }
                        catch (Exception ex)
                        {
                            return Problem("Database Connection Failed: " + ex.Message);
                        }
                    }
                    
                }
            }
            catch (Exception ex)
            {
                return Problem("Database Connection Failed[SqlConnection]: " + ex.Message);
            }
        }


    }
}
