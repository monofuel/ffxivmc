using FFXIVMarketApp.MarketData;
using FFXIVMarketApp.Utils;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace FFXIVMarketApp.Controls
{
    /// <summary>
    /// Interaction logic for MarketOrderControl.xaml
    /// </summary>
    public partial class MarketOrderControl : UserControl
    {
        ObservableCollection<MarketOrder> Orders = new ObservableCollection<MarketOrder>();

        public MarketOrderControl()
        {
            InitializeComponent();

            MarketGrid.ItemsSource = Orders;
            
        }

        public void SetCollection(IEnumerable NewOrders)
        {
            T.RunOnUI(() =>
            {
                var NewMarketOrders = NewOrders as List<MarketOrder>;
                Orders.Clear();
                foreach (var Order in NewMarketOrders)
                {
                    Orders.Add(Order);
                }
            });
        }
    }
}
