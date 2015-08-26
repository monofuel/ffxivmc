using FFXIVMarketApp.MarketData;
using FFXIVMarketApp.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace FFXIVMarketApp.Layout
{
    /// <summary>
    /// Interaction logic for MarketDataWindow.xaml
    /// </summary>
    public partial class MarketDataWindow : Window
    {
        public static MarketDataWindow Window;

        public MarketDataWindow()
        {
            InitializeComponent();

            Closed += (s, e) =>
            {
                Window = null;
            };

            Action IntervalAction = () =>
            {
                var Orders = Market.GetItemOrders(Market.LastItem);
                OrdersControl.SetCollection(Orders);
                L.WriteLine("Updating to " + Market.LastItem + " with " + Orders.Count + " Hits");
            };

            Loaded += (s, e) =>
            {
                E.Add("ItemInterval", IntervalAction);
                IntervalAction.Invoke();
            };

            Unloaded += (s, e) =>
            {
                E.Remove("ItemInterval", IntervalAction);
            };
        }

        public static void Open()
        {
            if (Window == null)
            {
                Window = new MarketDataWindow();
                Window.Show();
            } else
            {
                Window.Focus();
            }
        }
    }
}
