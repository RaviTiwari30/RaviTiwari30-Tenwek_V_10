using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Equipment_ProviderAMC : System.Web.UI.Page
{
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["ID"] == null)
        {
            Response.Redirect("~/Design/Default.aspx");
        }
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            bindcity();
            bindprovider();

        }
    }


    private void bindcity()
    {
        string str = "select distinct City from city_master where Country='India' order by City asc";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        ddlcity.DataSource = dt;
        ddlcity.DataTextField = "City";
        ddlcity.DataValueField = "City";
        ddlcity.DataBind();
        ddlcity.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlcity.SelectedIndex = 0;
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {

        if (btnsave.Text == "Save")
        {
            string ipcode = saveprovider();
        }
        else
        {
            updateprovider();
        }



        bindprovider();

    }

    protected void btnclear_Click(object sender, EventArgs e)
    {

        clearcontrol();

    }

    private void clearcontrol()
    {
        clear(txtname, txtph, txtadd1, txtadd2, txtconper1, txtconper2, txtmobile, txtpin, txtconper1desi, txtconper1email, txtconper2desi, txtconper2email, txtemail, txtfax, txtpin);
        bindcity();
        btnsave.Text = "Save";
        chkact.Checked = true;
        lbmsg.Text = "";
        lbip.Text = "";

    }
    private void clear(params TextBox[] tx)
    {
        foreach (TextBox t1 in tx)
        {
            t1.Text = string.Empty;
        }
    }

    private string saveprovider()
    {

        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        try
        {

            string inscode = "";
            bool IsActive = false;

            if (chkact.Checked)
                IsActive = true;

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("eqp_insertprovideinsurance");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter ipcode = new MySqlParameter();
            ipcode.ParameterName = "@ipcode";

            ipcode.MySqlDbType = MySqlDbType.VarChar;
            ipcode.Size = 30;
            ipcode.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            cmd.Parameters.Add(new MySqlParameter("@Name", txtname.Text));
            cmd.Parameters.Add(new MySqlParameter("@State", ""));
            cmd.Parameters.Add(new MySqlParameter("@City", ddlcity.SelectedItem.Text));
            cmd.Parameters.Add(new MySqlParameter("@add1", txtadd1.Text));
            cmd.Parameters.Add(new MySqlParameter("@add2", txtadd2.Text));
            cmd.Parameters.Add(new MySqlParameter("@Pin", txtpin.Text));
            cmd.Parameters.Add(new MySqlParameter("@ph", txtph.Text));
            cmd.Parameters.Add(new MySqlParameter("@mo", txtmobile.Text));
            cmd.Parameters.Add(new MySqlParameter("@fax", txtfax.Text));
            cmd.Parameters.Add(new MySqlParameter("@email", txtemail.Text));
            cmd.Parameters.Add(new MySqlParameter("@conper1", txtconper1.Text));
            cmd.Parameters.Add(new MySqlParameter("@conper1desi", txtconper1desi.Text));
            cmd.Parameters.Add(new MySqlParameter("@conper1email", txtconper1email.Text));
            cmd.Parameters.Add(new MySqlParameter("@conper2", txtconper2.Text));
            cmd.Parameters.Add(new MySqlParameter("@conper2desi", txtconper2desi.Text));
            cmd.Parameters.Add(new MySqlParameter("@conper2email", txtconper2email.Text));
            cmd.Parameters.Add(new MySqlParameter("@insertby", ViewState["ID"].ToString()));
            cmd.Parameters.Add(new MySqlParameter("@isactive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@prdtype", "AMC"));


            cmd.Parameters.Add(ipcode);

            //cmd.ExecuteNonQuery();

            inscode = cmd.ExecuteScalar().ToString();





            this.objTrans.Commit();
            this.objCon.Close();


            lbmsg.Text = "Record Saved.";
            return inscode;

        }
        catch (Exception ex)
        {
            this.objTrans.Rollback();
            this.objCon.Close();
            this.objTrans.Dispose();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lbmsg.Text = ex.Message;
            return "";

        }
    }

    private void updateprovider()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        try
        {
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            bool IsActive = false;

            if (chkact.Checked)
                IsActive = true;

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE eq_providerinsurance ");
            objSQL.Append("SET NAME = '" + txtname.Text + "',City = '" + ddlcity.SelectedItem.Text + "',Address1 = '" + txtadd1.Text + "',Address2 = '" + txtadd2.Text + "',Pincode = '" + txtpin.Text + "',Telephone = '" + txtph.Text + "', ");
            objSQL.Append("Mobile = '" + txtmobile.Text + "',FaxNo= '" + txtfax.Text + "',Email = '" + txtemail.Text + "',Conper1 = '" + txtconper1.Text + "',Conper1desi = '" + txtconper1desi.Text + "',Conper1email = '" + txtconper1email.Text + "',Conper2 = '" + txtconper2.Text + "',");
            objSQL.Append("Conper2desi = '" + txtconper2desi.Text + "',Conper2email = '" + txtconper2email.Text + "',Updateby = '" + ViewState["ID"].ToString() + "',Updatedate = NOW(),IsActive = " + IsActive + " ");
            objSQL.Append(" WHERE Id ='" + lbip.Text + "'");

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.ExecuteNonQuery();


            this.objTrans.Commit();
            this.objCon.Close();


            lbmsg.Text = "Record Updated.";


        }
        catch (Exception ex)
        {
            this.objTrans.Rollback();
            this.objCon.Close();
            this.objTrans.Dispose();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lbmsg.Text = ex.Message;


        }
    }

    private void bindprovider()
    {
        string str = "select * from eq_providerinsurance where providertype='AMC'";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            grddetail.DataSource = dt;
            grddetail.DataBind();
        }
    }

    private void bindprovider(string ipcode)
    {
        string str = "select * from eq_providerinsurance where ipcode='" + ipcode + "'";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        foreach (DataRow dw in dt.Rows)
        {
            lbip.Text = dw["id"].ToString();
            txtname.Text = dw["name"].ToString();
            txtadd1.Text = dw["Address1"].ToString();
            txtadd2.Text = dw["Address2"].ToString();
            txtpin.Text = dw["Pincode"].ToString();
            txtph.Text = dw["Telephone"].ToString();
            txtmobile.Text = dw["Mobile"].ToString();
            txtfax.Text = dw["FaxNo"].ToString();
            txtemail.Text = dw["Email"].ToString();
            txtconper1.Text = dw["Conper1"].ToString();
            txtconper1desi.Text = dw["Conper1desi"].ToString();

            txtconper1email.Text = dw["Conper1email"].ToString();
            txtconper2.Text = dw["Conper2"].ToString();
            txtconper2desi.Text = dw["Conper2desi"].ToString();
            txtconper2email.Text = dw["Conper2email"].ToString();

            ddlcity.SelectedValue = dw["city"].ToString();

            if (dw["IsActive"].ToString() == "True")
            {
                chkact.Checked = true;
            }
            else
            {
                chkact.Checked = false;
            }


        }
    }

    protected void grddetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string ipcode = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
            bindprovider(ipcode);
            btnsave.Text = "Update";
        }
        else
        {
            lblLog.Text = "Insert By :- " + StockReports.ExecuteScalar(@"SELECT CONCAT(em.Name,' ',insertdate) insertBy  FROM eq_providerinsurance ps INNER JOIN employee_master em ON em.employee_id=ps.insertby WHERE ps.ipcode='" + ipcode + "'");


            mdpLog.Show();
        }
    }
}