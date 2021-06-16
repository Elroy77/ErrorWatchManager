using System;
using ErrorWatch.Models;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ErrorWatch.Controllers
{
    public class OrdersController : BaseController
    {
        string connectionString = "Data Source=.;Initial Catalog=db_ErrorWatch;Integrated Security=True";
        public void setAlert(string message, string type)
        {
            TempData["AlertMessage"] = message;
            if (type == "success")
            {
                TempData["AlertType"] = "alert-success";
            }
        }
        // GET: Orders
        [HttpGet]
        public ActionResult Index()
        {
            DataTable dtbOrders = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "select DISTINCT Orders.Order_ID, Users.User_FullName, Users.Phone, Note, Total, Orders.Status from Orders,OrderDetails,Users,Products where Orders.Order_ID = OrderDetails.Order_ID and Orders.User_ID = Users.User_ID and OrderDetails.Product_ID = Products.Product_ID";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.Fill(dtbOrders);
            }
            return View(dtbOrders);
        }
        public ActionResult Update(int id)
        {
            OrderDetail orderDetailModel = new OrderDetail();
            DataTable dtbOrders = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "select Order_ID,sum(Quantity) from OrderDetails where Order_ID = @Order_ID group by Order_ID";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.SelectCommand.Parameters.AddWithValue("@Order_ID", id);
                sqlDA.Fill(dtbOrders);
            }
            if (dtbOrders.Rows.Count == 1)
            {
                orderDetailModel.OrderDetail_ID = Convert.ToInt32(dtbOrders.Rows[0][0].ToString());
                orderDetailModel.Quantity = Convert.ToInt32(dtbOrders.Rows[0][1].ToString());
                return View(dtbOrders);
            }
            else
                return RedirectToAction("Index");
        }
        public ActionResult viewchitietdonhang()
        {
            DataTable dtb = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "select * from v_chitietdonhang";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.Fill(dtb);
            }
            return View(dtb);
        }
    }
}