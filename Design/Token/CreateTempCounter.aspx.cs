using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Token_CreateTempCounter : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindCounter();
        }
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string CheckCenterExists(string Countername)
    {
        string res = "";
        int IsExists = 0;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "SELECT COUNT(*) FROM Temp_Counter WHERE CounterName='" + Countername + "' AND IsActive=1";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            IsExists = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
        }
        if (IsExists > 0)
        {
            res = "YES";
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(res);
    }
    protected void btnSave_Click(object sender, EventArgs e) // developed by Ankit
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string counter = txtCounter.Text.Trim();

        string query = "INSERT INTO Temp_Counter(Countername) VALUES(@Countername)";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@Countername", counter);
            cmd.ExecuteNonQuery();

            cmd.Parameters.Clear();
            con.Close();
            lblmsg.Text = "Saved Successfully";
            txtCounter.Text = "";
            BindCounter();
        }
    }

    public void BindCounter()
    {
        DataSet ds = new DataSet();
        ds = GetCounter();
        int rowcount;
        rowcount = ds.Tables[0].Rows.Count;
        if (rowcount > 0)
        {
            dgGrid.DataSource = ds;
            dgGrid.DataBind();
        }
        else
        {
            lblmsg.Text = "Counter not found";
        }
    }

    public DataSet GetCounter()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        DataSet ds = new DataSet();
        MySqlDataAdapter Adp = new MySqlDataAdapter();

        string query = "SELECT * FROM Temp_Counter WHERE IsActive=1";
        using (MySqlCommand cmd = new MySqlCommand(query,con))
        {
            cmd.CommandType = CommandType.Text;
            Adp.SelectCommand = cmd;
            Adp.Fill(ds);
        }

        return ds;
    }

    //protected void dgGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    //{
    //    if (e.CommandName == "Delete")
    //    {
    //        int id = Convert.ToInt32(e.CommandArgument);
    //        UpdateActive(id);
    //        ScriptManager.RegisterStartupScript(this, this.GetType(), "script", "SuccessMsg();", true);
    //       // BindCounter();
    //    }
    //}

    public void UpdateActive(int id)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "UPDATE Temp_Counter SET IsActive=0 WHERE Id='" + id + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }
    protected void dgGrid_RowEditing(object sender, GridViewEditEventArgs e)
    {
        dgGrid.EditIndex = e.NewEditIndex;
        this.BindCounter();
    }
    protected void dgGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridViewRow row = dgGrid.Rows[e.RowIndex];
        int id = Convert.ToInt32(dgGrid.DataKeys[e.RowIndex].Values[0]);
        string counter = (row.FindControl("txtEditCounter") as TextBox).Text;
        UpdateCounter(id, counter);
        dgGrid.EditIndex = -1;
        this.BindCounter();
    }
    protected void dgGrid_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        dgGrid.EditIndex = -1;
        this.BindCounter();
    }

    public void UpdateCounter(int id, string counter)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "UPDATE Temp_Counter SET CounterName='" + counter + "' WHERE Id='" + id + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }
    protected void dgGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int id = Convert.ToInt32(dgGrid.DataKeys[e.RowIndex].Values[0]);
        UpdateActive(id);
        this.BindCounter();
    }
}