using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FFXIVMarketApp.MarketData
{

    class MarketOrder
    {
        public int Item { get; set; }
        public int Price { get; set; }
        public int Quantity { get; set; }
        public bool HQ { get; set; }
        public int Total { get; set; }
        public int MarketCode { get; set; }
        public string Retainer { get; set; }

        public string MarketName
        {
            get
            {
                switch (MarketCode)
                {
                    case 60881:
                        return "Limsa";
                    case 60882:
                        return "Gridania";
                    case 60883:
                        return "Ul'Dah";
                    case 60884:
                        return "Foundation";
                    default:
                        return "Unknown Market";
                }
            }
        }

        override public string ToString()
        {
            return String.Format("Item: {0} Price: {1} Quantity: {2} HQ: {3} Total: {4} Retainer: {5}",
                Item, Price, Quantity, HQ, Total, Retainer);
        }
    }
}
