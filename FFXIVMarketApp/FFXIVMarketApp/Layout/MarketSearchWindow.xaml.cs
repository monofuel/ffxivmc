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
    public partial class MarketSearchWindow : Window
    {
        public static MarketSearchWindow Window;
        private int CurrentItem;

        public MarketSearchWindow()
        {
            InitializeComponent();

            Closed += (s, e) =>
            {
                Window = null;
            };

            Action IntervalAction = () =>
            {
                if (Market.LastItem == CurrentItem)
                {
                    var Orders = Market.GetItemOrders(CurrentItem);
                    OrdersControl.SetCollection(Orders);
                    L.WriteLine("reloading search with new data");
                }
            };

            Loaded += (s, e) =>
            {
                E.Add("ItemInterval", IntervalAction);
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
                Window = new MarketSearchWindow();
                Window.Show();
            } else
            {
                Window.Focus();
            }
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            var Input = Item.Text;
            int ItemId;
            if (int.TryParse(Input,out ItemId))
            {
                OrdersControl.SetCollection(Market.GetItemOrders(ItemId));
                CurrentItem = ItemId;
            } else
            {
                throw new NotImplementedException();
            }
        }
    }
}
