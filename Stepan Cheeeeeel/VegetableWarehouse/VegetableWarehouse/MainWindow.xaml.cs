using System;
using System.Windows;
using System.Windows.Controls;
using System.Data;
using System.Collections.Generic;
using DBConnect;

namespace VegetableWarehouse
{
    public partial class MainWindow : Window
    {
        private DB conn;
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
                conn = new DB(DBNameTxtBox.Text, UsernameTxtBox.Text, PwdBox.Password);
                conn.DbConnect();
                ConnectBtn.IsEnabled = false;
                DisconnectBtn.IsEnabled = true;

                DataTable tmp = conn.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'; ");
                foreach (DataRow row in tmp.Rows)
                {
                    for (int i = 0; i < tmp.Columns.Count; i++)
                    {
                        TablesList.Items.Add(row[i].ToString());
                    }
                }

                ShowOffersBtn.IsEnabled = true;
                SellSeedsBtn.IsEnabled = true;
                BuySeedsBtn.IsEnabled = true;
                CalculateFacilityBtn.IsEnabled = true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                MessageBox.Show(ex.Message, "Ошибка при подключении!");
            }
        }

        private void DisconnectBtn_Click(object sender, RoutedEventArgs e)
        {
            conn.Disconnect();
            TablesList.Items.Clear();
            DbGrid.ItemsSource = null;
            conn = null;
            selTableName = null;
            ConnectBtn.IsEnabled = true;
            DisconnectBtn.IsEnabled = false;

            ShowOffersBtn.IsEnabled = false;
            SellSeedsBtn.IsEnabled = false;
            BuySeedsBtn.IsEnabled = false;
            CalculateFacilityBtn.IsEnabled = false;
        }
        private void TablesList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            string tableName = TablesList.SelectedItem.ToString();
            try
            {
                dt = conn.execute("SELECT * FROM " + tableName);
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
                try
                {
                    conn.execute(updateQuery);
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Ошибка при обновлении!\n" + ex, "SQL Error");
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
                    InsertWindow insert = new InsertWindow(DbGrid.Columns, selTableName, conn, dt);
                    insert.ShowDialog();
                    string query = "SELECT * FROM \"" + selTableName + "\"";
                    dt = conn.execute(query);
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
                    dt = conn.execute(query);
                    DbGrid.ItemsSource = dt.DefaultView;
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Ошибка при удалении!\n" + ex.Message, "Ошибка");
                }
            }
        }

        private void CalculatePriceButton_Click(object sender, RoutedEventArgs e)
        {
            
        }

        private void ShowOffersBtn_Click(object sender, RoutedEventArgs e)
        { 
            try
            {
                string query = "SELECT * FROM V_ShowOffers";
                dt = conn.execute(query);

                DbGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }

        private void BuySeedsBtn_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string value = '\'' + BuySeedsTxtBox.Text.Replace("\'", "") + '\'';

                string query = "CALL BuySeedsAccept(" + value + "); SELECT * FROM SeedsBuyOffer ORDER BY id";

                dt = conn.execute(query);

                DbGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }

        private void SellSeedsBtn_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string value = '\'' + SellSeedsTxtBox.Text.Replace("\'", "") + '\'';

                string query = "CALL SellSeedsAccept(" + value + "); SELECT * FROM SeedsSellOffer ORDER BY id";
                dt = conn.execute(query);

                DbGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }

        private void CalculateFacilityBtn_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string value = '\'' + CalculateFacilityTxtBox.Text.Replace("\'", "") + '\'';

                string query = "Select * from CalculateFacilityWorth(" + value + ");";
                dt = conn.execute(query);

                DbGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка");
            }
        }
    }
}
