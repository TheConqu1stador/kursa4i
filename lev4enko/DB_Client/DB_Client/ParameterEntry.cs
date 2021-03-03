using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DB_Client
{
    class ParameterEntry
    {
        public string Type { get; set; }
        public string Name { get; set; }
        public string Text { get; set; }
        public string getText()
        {
            return '\'' + Text + '\'';
        }
        public ParameterEntry(string type, string name)
        {
            Type = type;
            Name = name;
        }
    }
}
