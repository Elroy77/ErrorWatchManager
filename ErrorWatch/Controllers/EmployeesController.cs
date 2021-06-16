using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ErrorWatch.Controllers
{
    public class EmployeesController : BaseController
    {
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var session = Session["USER_SESSION"];
            if (session.ToString() != "admin")
            {
                session = null;
                filterContext.Result = new RedirectToRouteResult(new System.Web.Routing.RouteValueDictionary
                    (new { controller = "Login", action = "Index" }));
            }
            base.OnActionExecuting(filterContext);
        }
        string connectionString = "Data Source=.;Initial Catalog=db_ErrorWatch;Integrated Security=True";
        public void setAlert(string message, string type)
        {
            TempData["AlertMessage"] = message;
            if (type == "success")
            {
                TempData["AlertType"] = "alert-success";
            }
        }
        // GET: Employees
        [HttpGet]
        public ActionResult Index(string searchString)
        {
            DataTable dtbUsers = new DataTable();
            if (searchString == null)
            {
                using (SqlConnection sqlCon = new SqlConnection(connectionString))
                {
                    sqlCon.Open();
                    string query = "select * from Employees";
                    SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                    sqlDA.Fill(dtbUsers);
                }
            }
            return View(dtbUsers);
        }
    }
}