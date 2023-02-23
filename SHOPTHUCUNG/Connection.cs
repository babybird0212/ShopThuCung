using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SHOPTHUCUNG
{
    class Connection
    {
        public static SqlConnection connect = new SqlConnection(@"Data Source=MSI\SQLEXPRESS;Initial Catalog=SHOPTHUCUNG;Integrated Security=True");
    }
}
