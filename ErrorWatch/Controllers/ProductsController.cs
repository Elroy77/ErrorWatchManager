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
    public class ProductsController : BaseController
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
        // GET: Products
        [HttpGet]
        public ActionResult Index(string searchString)
        {
            DataTable dtbProducts = new DataTable();
            if (searchString == null)
            {
                using (SqlConnection sqlCon = new SqlConnection(connectionString))
                {
                    sqlCon.Open();
                    string query = "select * from Products";
                    SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                    sqlDA.Fill(dtbProducts);
                }
            }
            else
            {
                using (SqlConnection sqlCon = new SqlConnection(connectionString))
                {
                    sqlCon.Open();
                    string query = "select * from timkiem_theten (@Name)";
                    SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                    sqlDA.SelectCommand.Parameters.AddWithValue("@Name", searchString);
                    sqlDA.Fill(dtbProducts);
                }
            }
            return View(dtbProducts);

        }
        [HttpGet]
        public ActionResult Create()
        {
            return View(new Product());
        }

        [HttpPost]
        public ActionResult Create(Product productsModel)
        {
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string queryCreate = "exec insert_product @name_P = @Product_Name,@price = @Price, @size =@Size, @gender=@Gender, @description =@Desciption, @inventory_number =@Inventory_Number, @manu =@Manufacturer_ID, @status=@Status";
                SqlCommand sqlCmd = new SqlCommand(queryCreate, sqlCon);
                sqlCmd.Parameters.AddWithValue("@Product_Name", productsModel.Product_Name);
                sqlCmd.Parameters.AddWithValue("@Price", productsModel.Price);
                sqlCmd.Parameters.AddWithValue("@Size", productsModel.Size);
                sqlCmd.Parameters.AddWithValue("@Gender", productsModel.Gender);
                sqlCmd.Parameters.AddWithValue("@Desciption", productsModel.Desciption);
                sqlCmd.Parameters.AddWithValue("@Inventory_Number", productsModel.Inventory_Number);
                sqlCmd.Parameters.AddWithValue("@Manufacturer_ID", productsModel.Manufacturer_ID);
                sqlCmd.Parameters.AddWithValue("@Status", productsModel.Status);
                sqlCmd.ExecuteNonQuery();
            }
            setAlert("Thêm mới sản phẩm thành công", "success");
            return RedirectToAction("Index");
        }
        public ActionResult Update(int id)
        {
            Product productModel = new Product();
            DataTable dtbProducts = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "Select * from Products where Product_ID = @Product_ID";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.SelectCommand.Parameters.AddWithValue("@Product_ID", id);
                sqlDA.Fill(dtbProducts);
            }
            if (dtbProducts.Rows.Count == 1)
            {
                productModel.Product_ID = Convert.ToInt32(dtbProducts.Rows[0][0].ToString());
                productModel.Product_Name = dtbProducts.Rows[0][1].ToString();
                productModel.Price = Convert.ToInt32(dtbProducts.Rows[0][2].ToString());
                productModel.Size = Convert.ToInt32(dtbProducts.Rows[0][3].ToString());
                productModel.Gender = Convert.ToInt32(dtbProducts.Rows[0][4].ToString());
                productModel.Desciption = dtbProducts.Rows[0][6].ToString();
                productModel.Inventory_Number = Convert.ToInt32(dtbProducts.Rows[0][7].ToString());
                productModel.Manufacturer_ID = Convert.ToInt32(dtbProducts.Rows[0][8].ToString());
                productModel.Status = Convert.ToBoolean(dtbProducts.Rows[0][9].ToString());
                return View(productModel);
            }
            else
                return RedirectToAction("Index");
        }
        [HttpPost]
        public ActionResult Update(Product productModel)
        {
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string queryUpdate = "update Products set Product_Name=@Product_Name, Price=@Price, Size=@Size, Gender=@Gender, Desciption=@Desciption, Inventory_Number=@Inventory_Number,Manufacturer_ID=@Manufacturer_ID, Status=@Status where Product_ID=@Product_ID";
                SqlCommand sqlCmd = new SqlCommand(queryUpdate, sqlCon);
                sqlCmd.Parameters.AddWithValue("@Product_ID", productModel.Product_ID);
                sqlCmd.Parameters.AddWithValue("@Product_Name", productModel.Product_Name);
                sqlCmd.Parameters.AddWithValue("@Price", productModel.Price);
                sqlCmd.Parameters.AddWithValue("@Size", productModel.Size);
                sqlCmd.Parameters.AddWithValue("@Gender", productModel.Gender);
                sqlCmd.Parameters.AddWithValue("@Desciption", productModel.Desciption);
                sqlCmd.Parameters.AddWithValue("@Inventory_Number", productModel.Inventory_Number);
                sqlCmd.Parameters.AddWithValue("@Manufacturer_ID", productModel.Manufacturer_ID);
                sqlCmd.Parameters.AddWithValue("@Status", productModel.Status);
                sqlCmd.ExecuteNonQuery();
            }
            setAlert("Cập nhật thông tin sản phẩm thành công", "success");
            return RedirectToAction("Index");
        }

        public ActionResult Delete(int id)
        {
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string queryDelete = "delete from Products where Product_ID=@Product_ID";
                SqlCommand sqlCmd = new SqlCommand(queryDelete, sqlCon);
                sqlCmd.Parameters.AddWithValue("@Product_ID", id);
                sqlCmd.ExecuteNonQuery();
            }
            setAlert("Xóa sản phẩm thành công", "success");
            return RedirectToAction("Index");
        }

        public ActionResult Detail(int id)
        {
            Product productModel = new Product();
            DataTable dtbProducts = new DataTable();
            using (SqlConnection sqlCon = new SqlConnection(connectionString))
            {
                sqlCon.Open();
                string query = "Select * from Products where Product_ID = @Product_ID";
                SqlDataAdapter sqlDA = new SqlDataAdapter(query, sqlCon);
                sqlDA.SelectCommand.Parameters.AddWithValue("@Product_ID", id);
                sqlDA.Fill(dtbProducts);
            }
            if (dtbProducts.Rows.Count == 1)
            {
                productModel.Product_ID = Convert.ToInt32(dtbProducts.Rows[0][0].ToString());
                productModel.Product_Name = dtbProducts.Rows[0][1].ToString();
                productModel.Price = Convert.ToInt32(dtbProducts.Rows[0][2].ToString());
                productModel.Size = Convert.ToInt32(dtbProducts.Rows[0][3].ToString());
                productModel.Gender = Convert.ToInt32(dtbProducts.Rows[0][4].ToString());
                productModel.Image = dtbProducts.Rows[0][5].ToString();
                productModel.Desciption = dtbProducts.Rows[0][6].ToString();
                productModel.Inventory_Number = Convert.ToInt32(dtbProducts.Rows[0][7].ToString());
                productModel.Manufacturer_ID = Convert.ToInt32(dtbProducts.Rows[0][8].ToString());
                productModel.Status = Convert.ToBoolean(dtbProducts.Rows[0][9].ToString());
                return View(productModel);
            }
            else
                return RedirectToAction("Index");
        }
    }
}