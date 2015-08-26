using FFXIVMarketApp.MarketData;
using FFXIVMarketApp.Utils;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace FFXIVMarketApp.MemoryScan
{
    

    class FFReader
    {
        [DllImport("kernel32.dll")]
        public static extern IntPtr OpenProcess(int dwDesiredAccess, bool bInheritHandle, int dwProcessId);

        [DllImport("kernel32.dll")]
        public static extern bool ReadProcessMemory(IntPtr hProcess,
          int lpBaseAddress, byte[] lpBuffer, int dwSize, ref int lpNumberOfBytesRead);

        private Process FF_PROC;
        private IntPtr FF_HANDLE;

        public static readonly List<FFReader> Readers = new List<FFReader>();

        public static FFReader R
        {
            get
            {
                if (Readers.Count == 0)
                    return new FFReader();
                else
                   return Readers.FirstOrDefault();
            }
        }

        private const int PROCESS_WM_READ = 0x0010;

        private const int MARKET_PTR = 0x0F640FE4;
        private const int ITEM_SEARCH_PTR = 0x0F6417D0;
        private const int MARKET_MESSAGE_PTR = 0x31561E22;
        private const int ORDER_BASE = MARKET_PTR + 4;
        private const int QUANTITY_OFFSET = 4;
        private const int HQ_OFFSET = 8;
        private const int MARKET_OFFSET = 12;

        public FFReader()
        {

            FF_PROC = Process.GetProcessesByName("ffxiv_dx11").FirstOrDefault();

            if (FF_PROC == null) {
                L.Notify("Failed to find FFXIV process");
                return;
            }

            FF_HANDLE = OpenProcess(PROCESS_WM_READ, false, FF_PROC.Id);
            L.WriteLine("found FFXIV process: " + FF_PROC.Id);
            Readers.Add(this);

            FF_PROC.Exited += RemoveReader;
        }

        private void RemoveReader(object sender, System.EventArgs e)
        {
            Readers.Remove(this);
        }

        public int GetQuantity()
        {
            int Hits = ReadInt(MARKET_PTR);
            string Message = ReadString(MARKET_MESSAGE_PTR,14);
            if (Message == "No items found")
            {
                L.WriteLine("found 0 Hits");
                return 0;
            } else
            {
                if (Hits == 0)
                {
                    L.WriteLine("Item not loaded yet");
                    return -1;
                }
            }
            L.WriteLine("found " + Hits + " Hits");
            return Hits;
        }

        public MarketOrder GetItem(int Index)
        {
            var Order = new MarketOrder();

            int offset = ORDER_BASE + (20 * Index);

            Order.Item = ReadInt(ITEM_SEARCH_PTR);
            Order.Price = ReadInt(offset);
            Order.Quantity = ReadInt(offset + QUANTITY_OFFSET);
            Order.Total = Order.Price * Order.Quantity;
            Order.HQ = ReadInt(offset + HQ_OFFSET) == 1;
            Order.MarketCode = ReadInt(offset + MARKET_OFFSET);

            return Order;
            
        }
        public int GetCurrentItemId()
        {
            return ReadInt(ITEM_SEARCH_PTR);
        }

        public int GetProcessID()
        {
            if (FF_PROC == null)
                return 0;
            else
              return FF_PROC.Id;
        }

        private int ReadInt(int Pointer)
        {
            int BytesRead = 0;
            byte[] buf = new byte[4];
            ReadProcessMemory(FF_HANDLE, Pointer, buf, buf.Length, ref BytesRead);

            if (BytesRead == 0)
            {
                L.Notify("Failed to read value");
                return 0;
            }
            else
            {
                return BitConverter.ToInt32(buf, 0);
            }
        }

        private string ReadString(int Pointer,int length)
        {
            var String = "";

            int BytesRead = 0;
            byte[] buf = new byte[1];
            while (String.Length < length)
            {
                ReadProcessMemory(FF_HANDLE, Pointer++, buf, buf.Length, ref BytesRead);
                if (BytesRead != 1)
                {
                    L.Notify("Failed to read string value");
                    break;
                }
                if (buf[0] == 0)
                {
                    break;
                }
                String += Convert.ToChar(buf[0]);
            }


            return String;
        }
    }
}
