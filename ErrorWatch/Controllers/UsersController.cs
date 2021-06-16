using ErrorWatch.Models;
using Microsoft.SqlServer.Server;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ErrorWatch.Controllers
{
    public class UsersController : BaseController
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
        // GET: Users
        [HttpGet]
        public ActionResult Index(string searchString)
        {
            DataTable dtbUsers = new DataTable();
            if(searchString == null)
            {
                using (SqlConnection sqlCon = new SqlConnection(connectionString))
                {
                    sqlCon.Open();
                    string query = "select * from Users";
                    SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                    sqlDA.Fill(dtbUsers);
                }
            }
            else
            {
                using (SqlConnection sqlCon = new SqlConnection(connectionString))
                {
                    sqlCon.Open();
                    string query = "exec sp_search_User @userName = @User_Name";
                    SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                    sqlDA.SelectCommand.Parameters.AddWithValue("@User_Name", searchString);
                    sqlDA.Fill(dtbUsers);
                }
            }    
            return View(dtbUsers);
        }
        [HttpGet]
        public ActionResult Create()
        {
            return View(new User());
        }

        [HttpPost]
        public ActionResult Create(User usersModel)
        {
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string queryCreate = "insert into Users (User_FullName, User_Name, User_Password, Email, Phone, Address, Role, Status) " +
                    "values (@User_FullName,@User_Name,@User_Password, @Email, @Phone, @Address, @Role, @Status)";
                SqlCommand sqlCmd = new SqlCommand(queryCreate, sqlCon);
                sqlCmd.Parameters.AddWithValue("@User_FullName",usersModel.User_FullName);
                sqlCmd.Parameters.AddWithValue("@User_Name", usersModel.User_Name);
                sqlCmd.Parameters.AddWithValue("@User_Password", usersModel.User_Password);
                sqlCmd.Parameters.AddWithValue("@Email", usersModel.Email);
                sqlCmd.Parameters.AddWithValue("@Phone", usersModel.Phone);
                sqlCmd.Parameters.AddWithValue("@Address", usersModel.Address);
                sqlCmd.Parameters.AddWithValue("@Role", usersModel.Role);
                sqlCmd.Parameters.AddWithValue("@Status", usersModel.Status);
                sqlCmd.ExecuteNonQuery();
            }
            setAlert("Thêm mới người dùng thành công", "success");
            return RedirectToAction("Index");
        }
        public ActionResult Update(int id)
        {
            User userModel = new User();
            DataTable dtbUsers = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "Select * from Users where User_ID = @User_ID";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.SelectCommand.Parameters.AddWithValue("@User_ID", id);
                sqlDA.Fill(dtbUsers);
            }
            if (dtbUsers.Rows.Count == 1)
            {
                userModel.User_ID = Convert.ToInt32(dtbUsers.Rows[0][0].ToString());
                userModel.User_FullName = dtbUsers.Rows[0][1].ToString();
                userModel.User_Name = dtbUsers.Rows[0][2].ToString();
                userModel.User_Password = dtbUsers.Rows[0][3].ToString();
                userModel.Email = dtbUsers.Rows[0][4].ToString();
                userModel.Phone = dtbUsers.Rows[0][5].ToString();
                userModel.Address = dtbUsers.Rows[0][6].ToString();
                userModel.Role = Convert.ToInt32(dtbUsers.Rows[0][8].ToString());
                userModel.Status = Convert.ToBoolean(dtbUsers.Rows[0][11].ToString());
                return View(userModel);
            }
            else
                return RedirectToAction("Index");
        }
        [HttpPost]
        public ActionResult Update(User userModel)
        {
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string queryUpdate = "exec USP_UpdateProfile @Fullname=@User_FullName,@UserName=@User_Name,@UserPassword = @User_Password, @Email = @Email, @Phone=@Phone, @Address =@Address,@Role=@Role,@Status = @Status, @UserId =@User_ID";
                SqlCommand sqlCmd = new SqlCommand(queryUpdate, sqlCon);
                sqlCmd.Parameters.AddWithValue("@User_ID", userModel.User_ID);
                sqlCmd.Parameters.AddWithValue("@User_FullName", userModel.User_FullName);
                sqlCmd.Parameters.AddWithValue("@User_Name", userModel.User_Name);
                sqlCmd.Parameters.AddWithValue("@User_Password", userModel.User_Password);
                sqlCmd.Parameters.AddWithValue("@Email", userModel.Email);
                sqlCmd.Parameters.AddWithValue("@Phone", userModel.Phone);
                sqlCmd.Parameters.AddWithValue("@Address", userModel.Address);
                sqlCmd.Parameters.AddWithValue("@Role", userModel.Role);
                sqlCmd.Parameters.AddWithValue("@Status", userModel.Status);
                sqlCmd.ExecuteNonQuery();
            }
            setAlert("Cập nhật thông tin người dùng thành công", "success");
            return RedirectToAction("Index");        
        }

        public ActionResult Delete(int id)
        {
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string queryDelete = "delete from Users where User_ID=@User_ID";
                SqlCommand sqlCmd = new SqlCommand(queryDelete, sqlCon);
                sqlCmd.Parameters.AddWithValue("@User_ID", id);
                sqlCmd.ExecuteNonQuery();
            }
            setAlert("Xóa người dùng thành công", "success");
            return RedirectToAction("Index");
        }
        public ActionResult Detail(int id)
        {
            User userModel = new User();
            DataTable dtbUsers = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "Select * from Users where User_ID = @User_ID";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.SelectCommand.Parameters.AddWithValue("@User_ID", id);
                sqlDA.Fill(dtbUsers);
            }
            if (dtbUsers.Rows.Count == 1)
            {
                userModel.User_ID = Convert.ToInt32(dtbUsers.Rows[0][0].ToString());
                userModel.User_FullName = dtbUsers.Rows[0][1].ToString();
                userModel.User_Name = dtbUsers.Rows[0][2].ToString();
                userModel.User_Password = dtbUsers.Rows[0][3].ToString();
                userModel.Email = dtbUsers.Rows[0][4].ToString();
                userModel.Phone = dtbUsers.Rows[0][5].ToString();
                userModel.Address = dtbUsers.Rows[0][6].ToString();
                userModel.Avatar = dtbUsers.Rows[0][7].ToString();
                userModel.Role = Convert.ToInt32(dtbUsers.Rows[0][8].ToString());
                userModel.Status = Convert.ToBoolean(dtbUsers.Rows[0][11].ToString());
                return View(userModel);
            }
            else
                return RedirectToAction("Index");
        }
    }
}