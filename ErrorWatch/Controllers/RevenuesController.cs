using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ErrorWatch.Controllers
{
    public class RevenuesController : BaseController
    {
        string connectionString = "Data Source=.;Initial Catalog=db_ErrorWatch;Integrated Security=True";
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
        // GET: Revenues
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult IndexTop()
        {
            DataTable dtbRevenue1 = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "select * from statistic1";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.Fill(dtbRevenue1);
            }
            return View(dtbRevenue1);
        }
        public ActionResult IndexSellingProduct()
        {
            DataTable dtbRevenue2 = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "select * from sellingProduct";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.Fill(dtbRevenue2);
            }
            return View(dtbRevenue2);
        }

        [HttpGet]
        public ActionResult UnsoldProducts(string stringtimeStart, string stringtimeEnd)
        {
            DataTable dtbRevenue3 = new DataTable();
            if (stringtimeStart != null && stringtimeEnd != null)
            {
                using (SqlConnection sqlCon = new SqlConnection(connectionString))
                {
                    sqlCon.Open();
                    string query = "exec UnsoIdProducts @timeStart = @stringtimeStart,@timeEnd = @stringtimeEnd";
                    SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                    sqlDA.SelectCommand.Parameters.AddWithValue("@stringtimeStart", stringtimeStart);
                    sqlDA.SelectCommand.Parameters.AddWithValue("@stringtimeEnd", stringtimeEnd);
                    ViewBag.timeStart = stringtimeStart;
                    ViewBag.timeEnd = stringtimeEnd;
                    sqlDA.Fill(dtbRevenue3);
                }
            }
            else
            {

            }    
            return View(dtbRevenue3);
        }
        public ActionResult RevenueForTheMonth()
        {
            DataTable dtbRevenue4 = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "select * from RenvenueForTheMonth";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.Fill(dtbRevenue4);
            }
            return View(dtbRevenue4);
        }
        [HttpGet]
        public ActionResult RevenueSelectTime(string stringtimeStart, string stringtimeEnd, string stringnameProduct)
        {
            DataTable dtbRevenue5 = new DataTable();
            if (stringtimeStart != null && stringtimeEnd != null)
            {
                using (SqlConnection sqlCon = new SqlConnection(connectionString))
                {
                    sqlCon.Open();
                    string query = "exec RevenueSelectTimeAndProduct @timeStart = @stringtimeStart,@timeEnd = @stringtimeEnd, @productName = @stringnameProduct";
                    SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                    sqlDA.SelectCommand.Parameters.AddWithValue("@stringtimeStart", stringtimeStart);
                    sqlDA.SelectCommand.Parameters.AddWithValue("@stringtimeEnd", stringtimeEnd);
                    sqlDA.SelectCommand.Parameters.AddWithValue("@stringnameProduct", stringnameProduct);
                    ViewBag.timeStart = stringtimeStart;
                    ViewBag.timeEnd = stringtimeEnd;
                    ViewBag.nameProduct = stringnameProduct;
                    sqlDA.Fill(dtbRevenue5);
                }
            }
            else
            {

            }
            return View(dtbRevenue5);
        }
        public ActionResult UfQuantityOfManufacturer()
        {
            DataTable dtbRevenue6 = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "SELECT  ProductName, ManufacturerName, Quantity FROM dbo.UF_Quantity_Of_Manufacturer()";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.Fill(dtbRevenue6);
            }
            return View(dtbRevenue6);
        }
        public ActionResult UspSortTotalPrice()
        {
            DataTable dtbRevenue7 = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "exec USP_SortTotalPrice";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.Fill(dtbRevenue7);
            }
            return View(dtbRevenue7);
        }
        public ActionResult ViewUsersEmployee()
        {
            DataTable dtbRevenue8 = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "select * from V_Users_Employee";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.Fill(dtbRevenue8);
            }
            return View(dtbRevenue8);
        }
        public ActionResult viewuser()
        {
            DataTable dtbRevenue9 = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "select * from viewuser";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.Fill(dtbRevenue9);
            }
            return View(dtbRevenue9);
        }
        [HttpGet]
        public ActionResult RevenuePerEmployee(string nameEmployee)
        {
            DataTable dtbRevenue10 = new DataTable();

            if (nameEmployee != null)
            {
                using (SqlConnection sqlCon = new SqlConnection(connectionString))
                {
                    sqlCon.Open();
                    string query = "select * from dbo.RevenuePerEmployee(@nameEmployee)";
                    SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                    sqlDA.SelectCommand.Parameters.AddWithValue("@nameEmployee", nameEmployee);
                    ViewBag.nameEmployee = nameEmployee;
                    sqlDA.Fill(dtbRevenue10);
                }
            }
            else
            {

            }    
            return View(dtbRevenue10);
        }
    }
}