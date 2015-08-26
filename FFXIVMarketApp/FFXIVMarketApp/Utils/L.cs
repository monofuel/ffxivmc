using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace FFXIVMarketApp.Utils
{
    static class L
    {

        

        public static void WriteLine(string line)
        {
            Console.WriteLine(line);
        }

        public static void Notify(string line)
        {
            MessageBox.Show(line);
            Console.WriteLine(line);
        }
    }
}
