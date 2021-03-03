using System;
using System.Windows;
using System.Windows.Controls;

using System.Collections.ObjectModel;
using System.Data;
using Npgsql;

namespace DB_Client
{
    public partial class Runner : Window
    {
        private NpgsqlConnection connection;
        private DataGrid grid;


        private ObservableCollection<RoutineEntry> _Routines;
        private ObservableCollection<RoutineEntry> Routines
        {
            get { return _Routines; }
            set { _Routines = value; }
        }

        public Runner()
        {
            InitializeComponent();
            Routines = new ObservableCollection<RoutineEntry>();
            comboBox.ItemsSource = Routines;
        }

        public void RefreshConnection(NpgsqlConnection _connection)
        {
            connection = _connection;
        }
        public void SendGrid(DataGrid _grid)
        {
            grid = _grid;
        }

        private void ComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                ObservableCollection<ParameterEntry> parameters = ((RoutineEntry)e.AddedItems[0]).Parameters;
                ArgsItemControl.ItemsSource = parameters;
            } catch (IndexOutOfRangeException)
            {
                ((ComboBox)sender).SelectedIndex = -1;
                ArgsItemControl.ItemsSource = null;
            }
        }

        public void ReloadRoutines()
        {
            try
            {
                if (connection != null)
                {
                    DataTable procs = GetRoutines();

                    Routines = new ObservableCollection<RoutineEntry>();
                    for (int i = 0; i < procs.Rows.Count; i++)
                    {
                        Routines.Add(new RoutineEntry(i, procs.Rows[i].Field<string>(0), procs.Rows[i].Field<string>(1) == "PROCEDURE" ? 'P' : 'F'));

                        DataTable parameters = GetParameters(Routines[i].Name);
                        for (int j = 0; j < parameters.Rows.Count; j++)
                        {
                            Routines[i].Parameters.Add(new ParameterEntry(parameters.Rows[j].Field<string>(0), parameters.Rows[j].Field<string>(1)));
                        }
                    }
                    comboBox.ItemsSource = Routines;
                }
            } catch (NpgsqlException exception)
            {
                Console.WriteLine("Can't load routines.\n" + exception.Message);
            }
        }

        private DataTable GetRoutines()
        {
            NpgsqlCommand command = new NpgsqlCommand("select concat(specific_schema, '.', routine_name) as procedure_name, routine_type from information_schema.routines " +
                                                     "where routine_schema not in ('pg_catalog', 'information_schema') order by procedure_name;", connection);
            NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(command);
            DataTable table = new DataTable();
            adapter.Fill(table);
            return table;
        }

        private DataTable GetParameters(string routineName)
        {
            routineName = routineName.Split('.')[1];
            NpgsqlCommand command = new NpgsqlCommand("select p.data_type, p.parameter_name " +
                                                    "from information_schema.routines r left join information_schema.parameters p on r.specific_schema = p.specific_schema and r.specific_name = p.specific_name " +
                                                    "where r.routine_schema not in ('pg_catalog', 'information_schema') AND p.parameter_mode = 'IN' AND r.routine_name = \'" + routineName + "\' order by p.ordinal_position;", connection);
            NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(command);
            DataTable table = new DataTable();
            adapter.Fill(table);
            return table;
        }

        private void ExecuteButton_Click(object sender, RoutedEventArgs e)
        {
            string query;
            if (((RoutineEntry)comboBox.SelectedItem).Type == 'P')
            {
                query = "exec " + ((RoutineEntry)comboBox.SelectedItem).Name + "(";
            } else
            {
                query = "SELECT * FROM " + ((RoutineEntry)comboBox.SelectedItem).Name + "(";
            }
            if (ArgsItemControl.Items.Count > 0)
            {
                query += ((ParameterEntry)ArgsItemControl.Items[0]).getText();
            }
            for (int i = 1; i < ArgsItemControl.Items.Count; i++)
            {
                query += ", " + ((ParameterEntry)ArgsItemControl.Items[i]).getText();
            }
            query += ")";
            try
            {
                NpgsqlCommand command = new NpgsqlCommand(query, connection);
                if (((RoutineEntry)comboBox.SelectedItem).Type == 'F')
                {
                    NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(command);
                    DataTable table = new DataTable();
                    adapter.Fill(table);
                    grid.ItemsSource = table.DefaultView;
                }
            } catch (NpgsqlException)
            {
                Console.WriteLine("Routine failed: " + query);
            }

        }
    }
}
