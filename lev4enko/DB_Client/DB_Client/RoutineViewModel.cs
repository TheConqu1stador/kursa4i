using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Collections.ObjectModel;

namespace DB_Client
{
    class RoutineViewModel
    {
        private static ObservableCollection<RoutineEntry> _Routines;
        public static ObservableCollection<RoutineEntry> Routines
        {
            get { return _Routines; }
            set { _Routines = value; }
        }

        private static RoutineEntry _Routine;
        public static RoutineEntry Routine
        {
            get { return _Routine; }
            set { _Routine = value; }
        }

        public RoutineViewModel()
        {
            Routines = new ObservableCollection<RoutineEntry>();
        }
    }
}
