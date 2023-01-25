using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

public partial class Design_Equipment_Masters_AssetMasterGRN : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {            
            //LastUpdatedby,UpdateDate,IPAddress
            ViewState["LastUpdatedby"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            ViewState["IsUpdate"] = "S";
            BindSupplierType();
            bindasset();
            BindGrn("");
        }
        lblMsg.Text = "";
    }

    private void bindasset()
    {
        DataTable dt = StockReports.GetDataTable("SELECT id, itemid,itemname,assetcode,serialno,DATE_FORMAT(acquireddate,'%d-%m-%Y') acquireddate,(CASE WHEN Isactive=1 THEN 'True' ELSE 'False' END) isactive,modelno  FROM eq_asset_master where fromgrn=1 ");

        grdAsset.DataSource = dt;
        grdAsset.DataBind();
       
    }
    private void BindSupplierType()
    {
        DataTable dt = StockReports.GetDataTable("Select SupplierTypeName,SupplierTypeID from eq_SupplierType_master where isActive=1 order by SupplierTypeName");
        ddlSupplierType.DataSource = dt;
        ddlSupplierType.DataTextField = "SupplierTypeName";
        ddlSupplierType.DataValueField = "SupplierTypeID";
        ddlSupplierType.DataBind();

        ddlSupplierType.Items.Insert(0, new ListItem("ALL", "ALL"));
        ddlSupplierType.SelectedIndex = 0;

        BindSupplierList(ddlSupplierType.SelectedValue);
    }

    private void BindSupplierList(string SupplierTypeID)
    {
        ddlSupplier.Items.Clear();

        string str = "Select VendorName,VenLedgerNo from f_vendormaster where isActive=1";

        if(SupplierTypeID.ToUpper() !="ALL")
            str += " and SupplierTypeID = " + SupplierTypeID + "";

        str += " order by VendorName";

        DataTable dt = StockReports.GetDataTable(str);
        ddlSupplier.DataSource = dt;
        ddlSupplier.DataTextField = "VendorName";
        ddlSupplier.DataValueField = "VenLedgerNo";
        ddlSupplier.DataBind();

        ddlSupplier.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlSupplier.SelectedIndex = 0;
    }

    private void BindGrn(string VenLedgerNo)
    {
        //ddlGrnNo.Items.Clear();
        //string str = "SELECT LedgerTransactionNO,DATE_FORMAT(DATE,'%d-%m-%Y') DATE FROM f_ledgertransaction WHERE IsCancel=0 AND TypeOfTnx IN ('Purchase','nmpurchase') ";

        //if (VenLedgerNo != "")
        //    str += " and LedgerNoCr = '" + VenLedgerNo + "' ";

        //str += " AND Date(Date)>='" + ucDateFrom.GetDateForDataBase() + "' AND Date(Date) <='" + ucDateFrom.GetDateForDataBase() + "' ";
        //str += " order by LedgerTransactionNO";

        //DataTable dt = StockReports.GetDataTable(str);
        //ddlGrnNo.DataSource = dt;
        //ddlGrnNo.DataTextField = "LedgerTransactionNO";
        //ddlGrnNo.DataValueField = "DATE";
        //ddlGrnNo.DataBind();

        //ddlGrnNo.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        //ddlGrnNo.SelectedIndex = 0;
    }
    
    protected void grdAsset_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string AssetID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_Asset_master WHERE id='" +AssetID+"'");
            if (dt != null && dt.Rows.Count > 0)
            {
                txtitemname.Text = dt.Rows[0]["itemname"].ToString();
                txtassetcode.Text = dt.Rows[0]["assetcode"].ToString();
                txtmodel.Text = dt.Rows[0]["modelno"].ToString();
                txtserial.Text = dt.Rows[0]["serialno"].ToString();
                lbit.Text = dt.Rows[0]["id"].ToString();
                if (dt.Rows[0]["isactive"].ToString() == "1")
                {
                    chk.Checked = true;
                }
                else
                {
                    chk.Checked = false;
                }
                btn_saveasset .Text  = "Update";
                ModalPopupExtender1.Show();
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar(@"SELECT CONCAT('Insert By-',em.Name,' Insert Date- ',DATE_FORMAT(insertdate,'%d-%m-%Y')) insertBy  FROM eq_asset_master ps 
INNER JOIN employee_master em ON em.employee_id=ps.insertby WHERE ps.id=" + AssetID);
            mdpLog.Show();
        }
    }

    protected void ddlSupplierType_SelectedIndexChanged(object sender, EventArgs e)
    {
        
        BindSupplierList(ddlSupplierType.SelectedValue);
    }

    protected void ddlSupplier_SelectedIndexChanged(object sender, EventArgs e)
    {
       
        BindGrn(ddlSupplier.SelectedValue);
    }

    protected void btnShowItem_Click(object sender, EventArgs e)
    {
        if (ddlGrnNo.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select GRN No...";
            ddlGrnNo.Focus();
            return;
        }
        else
        {
            binditem(ddlGrnNo.SelectedItem.Text, ddlGrnNo.SelectedValue);
        }


    }

   
    private void binditem(string grnno,string date)
    {
        StringBuilder sb = new StringBuilder(); 
        sb.Append(" select ItemID,ItemName,BatchNumber,UnitPrice,MRP,InitialCount qty,");
        sb.Append(" if(IsPost = 1,'true','false')Post,if(IsPost=3,'Rej.','NotRej.')IsReject,if(IsFree = 1,'true','false')Free,'Non Medical' itemtype");
        sb.Append(" from f_stock where LedgerTransactionNo = '" + grnno + "'");

        sb.Append("Union");

        sb.Append(" select ItemID,ItemName,BatchNumber,UnitPrice,MRP,InitialCount qty,");
        sb.Append(" if(IsPost = 1,'true','false')Post,if(IsPost=3,'Rej.','NotRej.')IsReject,if(IsFree = 1,'true','false')Free,'Medical' itemtype");
        sb.Append(" from f_stock where LedgerTransactionNo = '" + grnno + "'");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        dt.Columns.Add("grnno");
        dt.Columns.Add("grndate");
        dt.Columns.Add("VendorName");
        foreach (DataRow dw in dt.Rows)
        {
            dw["grnno"] = grnno;
            dw["grndate"] = date;
            dw["VendorName"] = ddlSupplier.SelectedItem.Text;
        }
        if (dt.Rows.Count > 0)
        {
            grdGRN.DataSource = dt;
            grdGRN.DataBind();
        }
    }

    protected void grdGRN_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string main = Util.GetString(e.CommandArgument);
        string itemid = main.Split('#')[0].ToString();
        string itename = main.Split('#')[1].ToString();
        if (e.CommandName == "EditData")
        {
            ModalPopupExtender1.Show();
            txtitemname.Text = itename;
            lbit.Text = itemid;
        }
    }

    protected void btn_saveasset_Click(object sender, EventArgs e)
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        MySqlTransaction tnx = conn.BeginTransaction();
        if (btn_saveasset.Text == "Save")
        {

            try
            {

                if (checkitem(lbit.Text))
                {
                    lblMsg.Text = "Asset Already Saved.";
                    return;
                }
                string str = "";
                int IsActive = 0;

                if (chk.Checked)
                    IsActive = 1;


                str = "Insert into eq_Asset_master(fromgrn,itemid,itemname,assetcode,serialno,acquireddate,Isactive,grnid,suppierid,modelno,insertby,insertdate,ipnumber)";
                str += "value('1','" + lbit.Text + "','" + txtitemname.Text + "','" + txtassetcode.Text + "','" + txtserial.Text + "',";
                str += " Now(),'" + IsActive + "','" + ddlGrnNo.SelectedItem.Text + "','" + ddlSupplier.SelectedValue + "','" + txtmodel.Text + "','" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"] .ToString()+ "')";




                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved";

                btn_saveasset.Text = "Save";
                clearcontrol();


            }
            catch (Exception ex)
            {
                tnx.Rollback();
                conn.Close();
                conn.Dispose();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblMsg.Text = ex.Message;
            }
        }
        else
        {
            try
            {

               
                string str = "";
                int IsActive = 0;

                if (chk.Checked)
                    IsActive = 1;




                str = "update eq_Asset_master set serialno='" + txtserial.Text + "', assetcode='" + txtassetcode.Text + "',isactive='" + IsActive + "',modelno='" + txtmodel.Text + "',updateby='" + ViewState["LastUpdatedby"].ToString() + "',Updatedate=Now() where id='"+lbit.Text+"'";


                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Updated";

                btn_saveasset.Text = "Save";
               
                bindasset();
                clearcontrol();

            }
            catch (Exception ex)
            {
                tnx.Rollback();
                conn.Close();
                conn.Dispose();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblMsg.Text = ex.Message;
            }
        }
    }

    bool checkitem(string itemid)
    {
        if (StockReports.ExecuteScalar("select count(*) from eq_asset_master where itemid='"+itemid+"'").ToString() == "1")
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    void clearcontrol()
    {
        txtassetcode.Text = "";
        txtitemname.Text = "";
        txtmodel.Text = "";
        txtserial.Text = "";
        ddlSupplier.SelectedIndex = 0;
        ddlSupplierType.SelectedIndex = 0;
        ddlGrnNo.SelectedIndex = 0;
    }
}