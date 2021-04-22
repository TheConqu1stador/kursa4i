using System;
using System.Windows;
using System.Windows.Controls;

using System.Data;
using Sqldb;

namespace Aviabase
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
                ConnectBtn.IsEnabled = false;
                hub = new db(HostTxtBox.Text, DBNameTxtBox.Text, UsernameTxtBox.Text, PwdBox.Password);
                hub.DbConnect();
                
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
                GetFlightsWithSeatsButton.IsEnabled = true;
                GetActiveFlights_Button.IsEnabled = true;
                GetMaxSeatsInCoolPlanes_Button.IsEnabled = true;
                GetDangerousPlanesInActionButton.IsEnabled = true;
                GetDestinationsOutButton.IsEnabled = true;
                UpdateRatingButton.IsEnabled = true;
                GetAirportsWithPlanesButton.IsEnabled = true;
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
            GetFlightsWithSeatsButton.IsEnabled = false;
            GetActiveFlights_Button.IsEnabled = false;
            GetMaxSeatsInCoolPlanes_Button.IsEnabled = false;
            GetDangerousPlanesInActionButton.IsEnabled = false;
            GetDestinationsOutButton.IsEnabled = false;
            UpdateRatingButton.IsEnabled = false;
            GetAirportsWithPlanesButton.IsEnabled = false;
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
            if (selTableName != null) 
            {
                string value = '\'' + ((TextBox)e.EditingElement).Text.ToString() + '\'';
                string updateQuery = "SELECT * FROM " + selTableName + "_update(";

                for (int i = 0; i < ((DataGrid)sender).Columns.Count; ++i)
                {
                    if (i != 0)
                        updateQuery += ", ";
                    if (((DataGrid)sender).Columns[i].Header == e.Column.Header)
                        updateQuery += value;
                    else
                        updateQuery += '\'' + ((DataRowView)e.Row.Item)[i].ToString() + "\'";
                }
                updateQuery += ");";

                Console.WriteLine(updateQuery);
                try
                {
                    hub.SendCommand(updateQuery);

                    if (!e.Row.IsEditing)
                    {
                        DbGrid.Items.Refresh();
                    }
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
                    string query = "SELECT * FROM " + selTableName + "_delete(" + ((DataRowView)DbGrid.SelectedItem)[0].ToString() + ");";

                    hub.SendCommand(query);

                    dt = hub.SendCommand("SELECT * FROM " + selTableName);

                    DbGrid.ItemsSource = dt.DefaultView;
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Ошибка при удалении!\n" + ex.Message, "Ошибка");
                }
            }
        }

        private void GetFlightsWithSeatsButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (GetFlightsWithSeats_TextBox.Text.ToString() != string.Empty)
                { 
                    string query = "SELECT * FROM q2a_GetFlightsWithSeats('" + GetFlightsWithSeats_TextBox.Text.ToString() + "')";
                    dt = hub.SendCommand(query);
                    GetFlightsWithSeats_TextBox.Text = "";
                    DbGrid.ItemsSource = dt.DefaultView;
                }
                else
                {
                    MessageBox.Show("Не заполнено количество мест");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }

        private void GetActiveFlights_Button_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string query = "SELECT * FROM q2b_GetActiveFlights()";
                dt = hub.SendCommand(query);

                DbGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }

        private void GetMaxSeatsInCoolPlanes_Button_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string query = "SELECT * FROM q2c_GetMaxSeatsInCoolPlanes()";
                dt = hub.SendCommand(query);

                DbGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }

        private void GetDangerousPlanesInActionButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string query = "SELECT * FROM q2c_GetDangerousPlanesInAction()";
                dt = hub.SendCommand(query);

                DbGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }

        private void GetAirportsWithPlanesButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string query = "SELECT * FROM q2e_GetAirportsWithPlanes()";
                dt = hub.SendCommand(query);

                DbGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }

        private void GetDestinationsOutButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (GetDestinationsOut_TextBox.Text.ToString() != string.Empty)
                {
                    string query = "SELECT * FROM q2d_GetDestinationsOut('" + GetDestinationsOut_TextBox.Text.ToString() + "')";
                    dt = hub.SendCommand(query);
                    GetDestinationsOut_TextBox.Text = "";
                    DbGrid.ItemsSource = dt.DefaultView;
                }
                else
                {
                    MessageBox.Show("Не заполнен город");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }

        private void UpdateRatingButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string query = "CALL q6_UpdateRating()";
                hub.SendCommand(query);

                query = "SELECT * FROM Companies";
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
