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

            var PostButton = new Button();
            var PostText = new TextBlock();
            PostText.Text = "Post";
            PostButton.Content = PostText;
            PostButton.Click += (s,e) =>
           {
               var Orders = Market.GetItemOrders(Market.LastItem);
               H.Post(Endpoints.MarketOrders(),Orders.ToJSON());
           };

            OrdersControl.MarketOrderDock.Children.Insert(0,PostButton);

            Closed += (s, e) =>
            {
                Window = null;
            };

            Action IntervalAction = () =>
            {
                var Orders = Market.GetItemOrders(Market.LastItem);
                OrdersControl.SetCollection(Orders.List);
                L.WriteLine("Updating to " + Market.LastItem + " with " + Orders.List.Count + " Hits");
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

        private void OrdersControl_Loaded(object sender, RoutedEventArgs e)
        {

        }
    }
}
