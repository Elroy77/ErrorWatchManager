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
    public class ManufacturersController : BaseController
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
        // GET: Manufacturer
        [HttpGet]
        public ActionResult Index()
        {
            DataTable dtbManufacturer = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "select * from Manufacturers";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.Fill(dtbManufacturer);
            }
            return View(dtbManufacturer);
        }
        [HttpGet]
        public ActionResult Create()
        {
            return View(new Manufacturer());
        }

        [HttpPost]
        public ActionResult Create(Manufacturer manufacturerModel)
        {
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string queryCreate = "insert into Manufacturers (Manufacturer_Name, Status) values (@Manufacturer_Name, @Status)";
                SqlCommand sqlCmd = new SqlCommand(queryCreate, sqlCon);
                sqlCmd.Parameters.AddWithValue("@Manufacturer_Name", manufacturerModel.Manufacturer_Name);
                sqlCmd.Parameters.AddWithValue("@Status", manufacturerModel.Status);
                sqlCmd.ExecuteNonQuery();
            }
            setAlert("Thêm mới hãng thành công", "success");
            return RedirectToAction("Index");
        }
        public ActionResult Update(int id)
        {
            Manufacturer manufacturerModel = new Manufacturer();
            DataTable dtbManufacturers = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "Select * from Manufacturers where Manufacturer_ID = @Manufacturer_ID";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.SelectCommand.Parameters.AddWithValue("@Manufacturer", id);
                sqlDA.Fill(dtbManufacturers);
            }
            if (dtbManufacturers.Rows.Count == 1)
            {
                manufacturerModel.Manufacturer_ID = Convert.ToInt32(dtbManufacturers.Rows[0][0].ToString());
                manufacturerModel.Manufacturer_Name = dtbManufacturers.Rows[0][1].ToString();
                manufacturerModel.Status = Convert.ToBoolean(dtbManufacturers.Rows[0][2].ToString());
                return View(manufacturerModel);
            }
            else
                return RedirectToAction("Index");
        }
        [HttpPost]
        public ActionResult Update(Manufacturer manufacturerModel)
        {
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string queryUpdate = "update Manufacturers set Manufacturer_Name=@Manufacturer_Name, Status=@Status where Manufacturer_ID=@Manufacturer_ID";
                SqlCommand sqlCmd = new SqlCommand(queryUpdate, sqlCon);
                sqlCmd.Parameters.AddWithValue("@Manufacturer_ID", manufacturerModel.Manufacturer_ID);
                sqlCmd.Parameters.AddWithValue("@Manufacturer_Name", manufacturerModel.Manufacturer_Name);
                sqlCmd.Parameters.AddWithValue("@Status", manufacturerModel.Status);
                sqlCmd.ExecuteNonQuery();
            }
            setAlert("Cập nhật thông tin hãng thành công", "success");
            return RedirectToAction("Index");
        }

        public ActionResult Delete(int id)
        {
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string queryDelete = "delete from Manufacturers where Manufacturer_ID=@Manufacturer_ID";
                SqlCommand sqlCmd = new SqlCommand(queryDelete, sqlCon);
                sqlCmd.Parameters.AddWithValue("@Manufacturer_ID", id);
                sqlCmd.ExecuteNonQuery();
            }
            setAlert("Xóa hãng thành công", "success");
            return RedirectToAction("Index");
        }
    }
}