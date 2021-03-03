using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Collections.ObjectModel;

namespace DB_Client
{
    class ParameterViewModel
    {
        private static ObservableCollection<ParameterEntry> _Parameters;
        public static ObservableCollection<ParameterEntry> Parameters
        {
            get { return _Parameters; }
            set { _Parameters = value; }
        }

        public ParameterViewModel()
        {
            Parameters = new ObservableCollection<ParameterEntry>();
        }
    }
}
