using System;

using System.Data;
using Npgsql;

namespace Sqldb
{
    public class db
    {
        private string host, dbName, username, password, connString;
        private NpgsqlConnection sc;
        private NpgsqlDataAdapter sda;
        public db(string _host, string _dbName, string _username, string _password)
        {
            host = _host;
            dbName = _dbName;
            username = _username;
            password = _password;
            connString = "Server=" + host + ";Port=5432;Database=" + dbName + ";User ID=" + username + ";Password=" + password + ";";
        }

        public void DbConnect()
        {
            sc = new NpgsqlConnection(connString);
            sda = new NpgsqlDataAdapter();

            sc.Open();
            Console.WriteLine("Connected.");
        }
        public DataTable SendCommand(string request)
        {
            DataTable dt = new DataTable();
            try
            {
                Console.WriteLine("Got query\n" + request);
                NpgsqlCommand command = new NpgsqlCommand(request, sc);

                sda = new NpgsqlDataAdapter(command);
                sda.Fill(dt);

                Console.WriteLine("Success.");
                return dt;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw e;
            }
        }

        public void Disconnect()
        {
            sc.Close();
        } 

    };

}
