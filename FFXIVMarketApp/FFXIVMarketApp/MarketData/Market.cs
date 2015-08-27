using FFXIVMarketApp.MemoryScan;
using FFXIVMarketApp.Utils;
using System;
using System.Collections.Generic;
using System.Diagnostics.Tracing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FFXIVMarketApp.MarketData
{
    static class Market
    {
        public static volatile int LastItem;
        private static int lastQuantity;
        private static bool Posted = false;
        private readonly static Dictionary<int, MarketOrderList> Orders = new Dictionary<int, MarketOrderList>();
        private static Task IntervalThread;

        public static void Init()
        {
            IntervalThread = T.IntervalThread(() =>
            {
                try {
                    int Item = FFReader.R.GetCurrentItemId();
                    //L.WriteLine("" + Item);
                    if (Item != LastItem)
                    {
                        L.WriteLine("new item");
                        lastQuantity = -1;
                        LastItem = Item;
                        Posted = false;
                    }

                    int OrderCount = FFReader.R.GetQuantity();

                    if (Item > 0 && lastQuantity == OrderCount && !Posted)
                    {
                        if (OrderCount != -1)
                        {

                            LastItem = Item;
                            ClearOrders(Item);
                            lock (Orders)
                            {
                                for (int i = 0; i < OrderCount; i++)
                                {
                                    AddOrder(FFReader.R.GetItem(i));
                                }
                            }
                            if (OrderCount > 0)
                            {
                                H.Post(Endpoints.MarketOrders(), Orders[LastItem].ToJSON());
                                L.WriteLine("Posted new orders");
                            }
                            Posted = true;
                            E.Post("ItemInterval");
                        }
                    }
                    else
                    {
                        E.Post("ItemInterval");
                    }
                    lastQuantity = OrderCount;

                } catch (Exception)
                {
                    L.WriteLine("market update failed");
                }
            }, 400);
        }

        public static MarketOrderList GetItemOrders(int Item)
        {
            lock(Orders)
            {
                if (Orders.ContainsKey(Item))
                    return Orders[Item];
                else
                    return new MarketOrderList();
            }
        }

        public static void AddOrder(MarketOrder Order)
        {
            if (!Orders.ContainsKey(Order.Item))
                Orders[Order.Item] = new MarketOrderList();
            Orders[Order.Item].Add(Order);
        }
        public static void ClearOrders(int Item)
        {
            lock (Orders) {
                if (Orders.ContainsKey(Item))
                {
                    Orders.Remove(Item);
                }
            }
        }
    }
}
