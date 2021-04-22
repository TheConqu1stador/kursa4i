using System;
using System.Windows;
using System.Windows.Controls;
using System.Data;
using System.Collections.Generic;
using DBConnect;

namespace Tasks
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

            DelRecordBtn.IsEnabled = false;
            AddRecordBtn.IsEnabled = false;
        }
        private void TablesList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (TablesList.SelectedItem != null)
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
                string query = "call " + selTableName + "_update(";

                for (int i = 0; i < ((DataGrid)sender).Columns.Count; ++i)
                {
                    if (((DataGrid)sender).Columns[i].Header == e.Column.Header)
                        query += value;
                    else
                        query += '\'' + ((DataRowView)e.Row.Item)[i].ToString().Replace("\'", "") + "\'";
                    query += ", ";
                }
                query = query.Substring(0, query.Length - 2) + ");";

                try
                {
                    conn.execute(query);
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
                    string query = "CALL " + selTableName + "_delete(" + ((DataRowView)DbGrid.SelectedItem)[0].ToString()  + "); SELECT * FROM " + selTableName + ";";
                    dt = conn.execute(query);
                    DbGrid.ItemsSource = dt.DefaultView;
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Ошибка при удалении!\n" + ex.Message, "Ошибка");
                }
            }
        }
    }
}
