using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace FFXIVMarketApp.Utils
{
    class H
    {
        public static void Post(Uri Destination,JObject Data)
        {
            var client = new HttpClient();
            var content = new StringContent(Data.ToString(),
                                            Encoding.UTF8,
                                            "application/json");

            L.WriteLine("POST " + Destination);
            try {
                var response = client.PostAsync(Destination,content);

                L.WriteLine("RESPONSE: " + response);
            } catch (Exception e)
            {
                L.WriteLine("Post failed");
                L.WriteLine(e.Message);
            }
        }

        public static void Get(Uri Destination, string Options )
        {
            var client = new HttpClient();

            L.WriteLine("GET " + Destination + Options);
            try
            {
                var response = client.GetAsync(Destination + Options);

                L.WriteLine("RESPONSE: " + response);
            }
            catch (Exception e)
            {
                L.WriteLine("Get failed");
                L.WriteLine(e.Message);
            }
        }
    }
}

