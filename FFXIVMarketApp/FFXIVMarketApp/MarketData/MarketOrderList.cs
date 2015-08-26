using FFXIVMarketApp.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FFXIVMarketApp.MarketData
{
    class MarketOrderList
    {
        public long Timestamp { get; set; }
        public List<MarketOrder> Orders { get; set; }

        public MarketOrderList()
        {
            Timestamp = T.UnixTimeNow();
            Orders = new List<MarketOrder>();
        }

        public void Add(MarketOrder Order)
        {
            Orders.Add(Order);
        }
    }
}
