using System;
using System.Windows;
using System.Windows.Controls;

using System.Data;
using Sqldb;

namespace AutoDB
{
    public partial class MainWindow : Window
    {
        private db hub;
        private DataTable dt;

        string selTableName;
        public MainWindow()
        {
            InitializeComponent();
        }


        private void ConnectBtn_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                hub = new db(HostTxtBox.Text, DBNameTxtBox.Text, UsernameTxtBox.Text, PwdBox.Password);
                hub.DbConnect();
                ConnectBtn.IsEnabled = false;
                DisconnectBtn.IsEnabled = true;

                DataTable tmp = hub.SendCommand("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'; ");
                foreach (DataRow row in tmp.Rows)
                {
                    for (int i = 0; i < tmp.Columns.Count; i++)
                    {
                        TablesComboBox.Items.Add(row[i].ToString());
                    }
                }

                SelectTableButton.IsEnabled = true;
                ActualizeButton.IsEnabled = true;
                CatalogButton.IsEnabled = true;
                CalculatePriceButton.IsEnabled = true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                MessageBox.Show(ex.Message, "Ошибка при подключении!");
            }
        }

        private void DisconnectBtn_Click(object sender, RoutedEventArgs e)
        {
            hub.Disconnect();
            TablesComboBox.Items.Clear();
            DbGrid.ItemsSource = null;
            hub = null;
            selTableName = null;
            ConnectBtn.IsEnabled = true;
            DisconnectBtn.IsEnabled = false;

            SelectTableButton.IsEnabled = false;
            ActualizeButton.IsEnabled = false;
            CatalogButton.IsEnabled = false;
            CalculatePriceButton.IsEnabled = false;
        }

        private void TBtn_Click(object sender, RoutedEventArgs e)
        {
            string tableName = TablesComboBox.Text;
            try
            {
                dt = hub.SendCommand("SELECT * FROM \"" + tableName + "\"");
                DbGrid.ItemsSource = dt.DefaultView;
                selTableName = tableName;

                DelRecordBtn.IsEnabled = true;
                AddRecordBtn.IsEnabled = true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }

        private void DbGrid_AutoGeneratingColumn(object sender, DataGridAutoGeneratingColumnEventArgs e)
        {
            if (e.PropertyType == typeof(System.DateTime))
                (e.Column as DataGridTextColumn).Binding.StringFormat = "yyyy-MM-dd";
        }

        private void DbGrid_CellEditEnding(object sender, DataGridCellEditEndingEventArgs e)
        {
            if (selTableName != null) {
                string value = '\'' +  ((TextBox)e.EditingElement).Text.ToString().Replace("\'", "") + '\'';
                string updateQuery = "UPDATE \"" + selTableName + "\" SET \"" + e.Column.Header + "\" = " + value 
                                   + " WHERE \"" + ((DataGrid)sender).Columns[0].Header + "\" = " + ((DataRowView)e.Row.Item)[0].ToString();
                Console.WriteLine(updateQuery);
                try
                {
                    hub.SendCommand(updateQuery);
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Failed to update!\n" + ex, "SQL Error");
                }
            } else
            {
                MessageBox.Show("Не выбрана таблица", "Внимание!");
            }
        }

        private void AddRecordBtn_Click(object sender, RoutedEventArgs e)
        {
            if (selTableName != null)
            {
                try
                {
                    string query = "INSERT INTO \"" + selTableName + "\" DEFAULT VALUES; SELECT * FROM \"" + selTableName + "\"";
                    dt = hub.SendCommand(query);
                    DbGrid.ItemsSource = dt.DefaultView;
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Ошибка при вставке!\n" + ex.Message, "Ошибка");
                }
            }
        }

        private void DelRecordBtn_Click(object sender, RoutedEventArgs e)
        {
            if (selTableName != null && DbGrid.Items.Count > 0 && DbGrid.SelectedItem != null)
            {
                try
                {
                    string query = "DELETE FROM \"" + selTableName + "\" WHERE \"" + DbGrid.Columns[0].Header + "\" = " 
                                 + ((DataRowView)DbGrid.SelectedItem)[0].ToString() + "; SELECT * FROM \"" + selTableName + "\"";
                    dt = hub.SendCommand(query);
                    DbGrid.ItemsSource = dt.DefaultView;
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Ошибка при удалении!\n" + ex.Message, "Ошибка");
                }
            }
        }

        private void ActualizeButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string query = "CALL public.\"Актуализация доверенностей\"()";
                hub.SendCommand(query);

                query = "SELECT * FROM \"Доверенность\"";
                dt = hub.SendCommand(query);

                DbGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }

        private void CatalogButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string query = "SELECT * FROM \"Каталог\"";
                dt = hub.SendCommand(query);

                DbGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }

        private void CalculatePriceButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string value = '\'' + CarNumberTxtBox.Text.Replace("\'", "") + '\'';

                string query = "SELECT * FROM \"Металлолом\"(" + value + ")";
                dt = hub.SendCommand(query);

                DbGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }
    }
}
