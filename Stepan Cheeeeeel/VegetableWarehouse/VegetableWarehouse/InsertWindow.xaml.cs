using System;
using System.Collections.ObjectModel;
using DBConnect;
using System.Data;

using System.Collections;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
namespace VegetableWarehouse
{
    /// <summary>
    /// Логика взаимодействия для InsertWindow.xaml
    /// </summary>
    public partial class InsertWindow : Window
    {
        private string tablename;
        private DB conn;
        private DataTable dt;
        List<TextBox> TextBoxList = new List<TextBox>();
        List<string> HeadersList = new List<string>();
        public InsertWindow(ObservableCollection<DataGridColumn> headers, string _tablename, DB _conn, DataTable _dt)
        {
            InitializeComponent();

            
            tablename = _tablename;
            conn = _conn;
            dt = _dt;

            int margin = 0;
            foreach (var header in headers)
            {
                Label lbl = new Label();
                lbl = (Label)GenerateControl(lbl, header.Header.ToString(), new Thickness(10, margin, 0, 0));
                
                margin += 30;
                InsertGrid.Children.Add(lbl);

                TextBox txt = new TextBox();
                txt = (TextBox)GenerateControl(txt, header.Header.ToString(), new Thickness(10, margin, 0, 0));
                
                InsertGrid.Children.Add(txt);
                Console.WriteLine(header.Header.ToString());

                margin += 30;

                TextBoxList.Add(txt);
                HeadersList.Add(header.Header.ToString());
            }

            Button btn = new Button();
            btn = (Button)GenerateControl(btn, "Вставить", new Thickness(10, margin + 30, 0, 30));
            btn.Click += InsertBtn_Click;
            InsertGrid.Children.Add(btn);
        }

        private object GenerateControl(ContentControl control, string header, Thickness margin)
        {
            control.Content = header;
            control.Width = 120;
            control.Height = 35;
            control.Margin = margin;
            control.HorizontalAlignment = HorizontalAlignment.Left;
            control.VerticalAlignment = VerticalAlignment.Top;

            return control;
        }

        private object GenerateControl(Control control, string header, Thickness margin)
        {
            control.Name = header.Replace(" ", string.Empty) + "_TextBox";
            control.Width = 120;
            control.Height = 35;
            control.Margin = margin;
            control.HorizontalAlignment = HorizontalAlignment.Left;
            control.VerticalAlignment = VerticalAlignment.Top;

            return control;
        }

        private void InsertBtn_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string query = "insert into " + tablename + "(";

                foreach(var header in HeadersList)
                {
                    query += header + ", ";
                }
                query = query.Substring(0, query.Length - 2);
                query += ") values (";

                int index = 0;
                foreach (var textBox in TextBoxList)
                {
                    query += '\'' + textBox.Text.Replace("\'", "") + "\' ,";
                    index++;
                }
                query = query.Substring(0, query.Length - 2);
                query += ")";
                dt = conn.execute(query);

                MessageBox.Show("Вставлено успешно");

                GetWindow(this).Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка при вставке!\n" + ex.Message, "Ошибка");
            }
        }
    }
}
