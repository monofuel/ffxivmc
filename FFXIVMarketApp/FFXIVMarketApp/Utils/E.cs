using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FFXIVMarketApp.Utils
{
    class E
    {
        private readonly static Dictionary<string, List<Action>> Listeners = new Dictionary<string, List<Action>>();

        public static void Add(string Type,Action A)
        {
            lock (Listeners)
            {
                if (!Listeners.ContainsKey(Type))
                    Listeners[Type] = new List<Action>();
                Listeners[Type].Add(A);
            }
        }

        public static void Remove(string Type,Action A)
        {
            lock (Listeners)
            {
                if (Listeners.ContainsKey(Type))
                {
                    Listeners[Type].Remove(A);
                }
            }
        }

        public static void Post(string Type)
        {
            if (Listeners.ContainsKey(Type))
            foreach(Action A in Listeners[Type])
                {
                    A.Invoke();
                }
        }
    }
}
