using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Collections.ObjectModel;

namespace DB_Client
{
    class RoutineEntry
    {
        public string Name { get; set; }
        public int Id { get; set; }
        public char Type { get; set; } // P / F
        public ObservableCollection<ParameterEntry> Parameters { get; set; }

        public RoutineEntry(int id, string name, char type)
        {
            Id = id;
            Name = name;
            Type = type;
            Parameters = new ObservableCollection<ParameterEntry>();
        }

    }
}
