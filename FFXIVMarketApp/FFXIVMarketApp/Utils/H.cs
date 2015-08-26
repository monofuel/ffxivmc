using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace FFXIVMarketApp.Utils
{
    class H
    {
        public static void Post(Uri Destination,JObject Data)
        {
            var Request = WebRequest.Create(Destination);

            var PostData = Encoding.ASCII.GetBytes(Data.ToString());

            Request.Method = "POST";
            Request.ContentType = "application/json";
            Request.ContentLength = PostData.Length;

            using (var stream = Request.GetRequestStream())
            {
                stream.Write(PostData, 0, PostData.Length);
            }
            L.WriteLine("POST " + Destination);
            var response = Request.GetResponse();
            L.WriteLine("RESPONSE: " + response);
        }

        public static void Get(Uri Destination, string Options )
        {
            var Request = WebRequest.Create(Destination + Options);

            Request.Method = "GET";

            L.WriteLine("GET " + Destination + Options);
            var response = Request.GetResponse();
            L.WriteLine("RESPONSE: " + response);
        }
    }
}

