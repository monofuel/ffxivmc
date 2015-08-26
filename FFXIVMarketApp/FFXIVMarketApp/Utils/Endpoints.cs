using FFXIVMarketApp.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FFXIVMarketApp.Utils
{
    class Endpoints
    {
        public static Uri MarketOrders()
        {
            return new Uri(C.Host, "/marketorder");
        }

    }
}
