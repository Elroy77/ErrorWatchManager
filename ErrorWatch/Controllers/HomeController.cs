using ErrorWatch.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
namespace ErrorWatch.Controllers
{
    public class HomeController : BaseController
    {
        string connectionString = "Data Source=.;Initial Catalog=db_ErrorWatch;Integrated Security=True";
        // GET: Home
        public ActionResult Index()
        {
            DataTable display = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "declare @sumUserIndex int declare @sumCartIndex int declare @sumOrderIndex int declare @sumMoneyIndex float exec sp_dashboardIndex @sumUserIndex output,@sumCartIndex output,@sumOrderIndex output,@sumMoneyIndex output select @sumUserIndex,@sumCartIndex,@sumOrderIndex,@sumMoneyIndex";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.Fill(display);
            }
            return View(display);
        }
    }
}