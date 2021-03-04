using System;
using System.Windows;
using System.Windows.Controls;

using Npgsql;
using System.Data;

namespace DB_Client
{
    public partial class MainWindow : Window
    {
        private NpgsqlConnection connection;

        private Runner w;
        public MainWindow()
        {
            InitializeComponent();
            w = new Runner();
            w.Show();
            w.SendGrid(DataBaseGrid);
        }

        private void ConnectButton_Click(object sender, RoutedEventArgs e)
        {
            if (connection != null)
            {
                connection.CloseAsync();
                w.RefreshConnection(null);
            }
            try
            {
                NpgsqlConnectionStringBuilder builder = new NpgsqlConnectionStringBuilder();
                builder.Database = "test3";
                builder.Host = AddressField.Text;
                builder.Username = UsernameField.Text;
                builder.Password = PasswordField.Password;
                connection = new NpgsqlConnection(builder.ConnectionString);
                connection.Open();
                w.RefreshConnection(connection);
                w.ReloadRoutines();
            } catch (NpgsqlException)
            {
                Console.WriteLine("Connection failed");
            }
        }

        private DataTable SendQuery(string request)
        {
            DataTable table = new DataTable();
            try
            {
                NpgsqlCommand command = new NpgsqlCommand(request, connection);
                NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(command);
                adapter.Fill(table);
            } catch (NpgsqlException)
            {
                Console.WriteLine("Command failed");
            } catch (InvalidCastException)
            {
                Console.WriteLine("Connect first");
            }
            return table;
        }

        private void TableButton_Click(object sender, RoutedEventArgs e)
        {
            DataTable table = SendQuery("SELECT * FROM public." + ((string)((Button)sender).Content).ToLower() + "_select()");
            DataBaseGrid.ItemsSource = table.DefaultView;
        }
    }
}
