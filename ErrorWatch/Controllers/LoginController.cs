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
    public class LoginController : Controller
    {
        string connectionString = "Data Source=.;Initial Catalog=db_ErrorWatch;Integrated Security=True";
        // GET: Login
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Login(User check)
        {
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                SqlCommand sqlCmd = new SqlCommand();
                SqlDataReader sqlDR;
                sqlCmd.Connection = sqlCon;
                sqlCmd.CommandText = "Select * from Users where User_Name = '" + check.User_Name + "' and User_Password = '" + check.User_Password + "' and Status = 'True' and Role >= 1";
                sqlDR = sqlCmd.ExecuteReader();
                if (sqlDR.Read())
                {

                    Session.Add("USER_SESSION", check.User_Name);
                    sqlCon.Close();
                    return RedirectToAction("../Home/Index");
                }
                else
                {
                    sqlCon.Close();
                    ViewBag.ErrorLogin = "Có lỗi đăng nhập mời bạn kiểm tra lại thông tin";
                    
                }
            }
            return View("Index");
        }
        public ActionResult LogOut()
        {
            Session["USER_SESSION"] = null;
            return Redirect("../Login/Index");
        }
    }
}