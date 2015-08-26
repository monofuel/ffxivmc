﻿using FFXIVMarketApp.Utils;
using Newtonsoft.Json.Linq;
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
        public List<MarketOrder> List { get; set; }

        public MarketOrderList()
        {
            Timestamp = T.UnixTimeNow();
            List = new List<MarketOrder>();
        }

        public void Add(MarketOrder Order)
        {
            List.Add(Order);
        }

        public JObject ToJSON()
        {
            JObject OrderList = new JObject();
            OrderList["timestamp"] = Timestamp;
            JArray JOrders = new JArray();
            foreach (var Order in List)
                JOrders.Add(Order.ToJSON());
            OrderList["orders"] = JOrders;

            return OrderList;
        }
    }
}
