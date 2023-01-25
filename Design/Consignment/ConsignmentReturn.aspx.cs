using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Consignment_ConsignmentReturn : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["RoleDept"] = Session["RoleID"].ToString();
            ViewState["EmpName"] = Session["LoginName"].ToString();
            ViewState["EmpID"] = Session["ID"].ToString();
            AllLoadData_Store.bindStore(ddlVendor, "VEN", "");
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //FrmDate.SetCurrentDate();
            //ToDate.SetCurrentDate();
        }
        txtFromDate.Attributes.Add("Readonly", "true");
        txtToDate.Attributes.Add("Readonly", "true");
        btnReturn.Attributes.Add("OnClick", "return valdt()");
    }

    protected void btnSearch_Click(object sender,EventArgs e)
    {
        search();
    }

    public void search()
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT t1.ConsignmentNo,t1.VendorLedgerNo,t1.itemid,t1.itemname,t1.BatchNumber,t1.rate,t1.InititalCount,t1.ReleasedCount,");
        //sb.Append(" t1.BalanceQty,t1.ReturnQuantity,t1.DeptLedgerNo,t1.MedExpiryDate,t1.ID,t1.postDate,t1.UnitPrice,t1.MRP,");
        //sb.Append(" t1.ConsignmentReturnID,t1.ReturnDate,t1.ReturnReason,t1.IsPost,t1.IsCancel FROM");
        //sb.Append(" (SELECT cond.ID,cond.ConsignmentNo,cond.PostDate,cond.InititalCount,(IFNULL(cond.ReleasedCount,0)- IFNULL(conr.ReturnQuantity,0)) AS ReleasedCount,");
        //sb.Append(" cond.VendorLedgerNo,cond.ItemID,cond.itemname,cond.BatchNumber,cond.MedExpiryDate, cond.UnitPrice,cond.Rate,cond.MRP,(cond.InititalCount-cond.ReleasedCount)BalanceQty,");
        //sb.Append(" IFNULL(conr.ReturnQuantity,0)ReturnQuantity,cond.DeptLedgerNo,cond.IsPost,cond.IsCancel,");
        //sb.Append(" conr.ConsignmentReturnID,conr.ReturnDate,conr.ReturnReason FROM Consignmentdetail cond");
        //sb.Append(" LEFT JOIN ConsignmentReturn conr ON cond.ID=conr.ConsignmentID)t1");
        //sb.Append("  WHERE BalanceQty>0");

        // sb.Append(" SELECT t1.* FROM ");
        //sb.Append(" ( SELECT cond.ID,cond.ConsignmentNo,cond.PostDate,cond.InititalCount,(IFNULL(cond.ReleasedCount,0)- IFNULL(conr.ReturnQuantity,0)) AS ReleasedCount, ");
        //sb.Append(" cond.VendorLedgerNo,cond.ItemID,cond.itemname,cond.BatchNumber,cond.MedExpiryDate,  ");
        //sb.Append(" cond.UnitPrice,cond.Rate,cond.MRP, ");
        //sb.Append(" (cond.InititalCount-cond.ReleasedCount)BalanceQty,  ");
        //sb.Append(" IFNULL(conr.ReturnQuantity,0)ReturnedQuantity, ");
        //sb.Append(" cond.DeptLedgerNo,cond.IsPost,cond.IsCancel,  ");
        //sb.Append(" conr.ConsignmentReturnID,conr.ReturnDate,conr.ReturnReason  ");
        //sb.Append(" FROM Consignmentdetail cond  ");
        //sb.Append(" LEFT OUTER JOIN (SELECT SUM(ReturnQuantity)ReturnQuantity,ReturnDate,ReturnReason,ConsignmentReturnID,ConsignmentNo,ItemID  FROM consignmentreturn GROUP BY ConsignmentNo,ItemID  ) conr  ");
        //sb.Append(" ON cond.ConsignmentNo=conr.ConsignmentNo ");
        //sb.Append(" )t1 WHERE BalanceQty >0   ");
        //sb.Append("   AND IsPost=1 AND IsCancel=0");


            sb.Append("  SELECT t1.* FROM   ");
            sb.Append("  ( SELECT cond.ID,cond.ConsignmentNo,Date_Format(cond.PostDate,'%d-%b-%y')PostDate,cond.InititalCount,(IFNULL(cond.ReleasedCount,0)- IFNULL(conr.ReturnQuantity,0)) AS ReleasedCount,  ");
            sb.Append("  cond.VendorLedgerNo,cond.ItemID,cond.itemname,cond.BatchNumber,MedExpiryDate,DATE_FORMAT(cond.MedExpiryDate,'%d-%b-%Y')MedExpDate ,  ");
            sb.Append("  ROUND((cond.UnitPrice/cond.CurrencyFactor),4)UnitPrice,ROUND((cond.Rate/cond.CurrencyFactor),4)Rate,ROUND((cond.MRP/cond.CurrencyFactor),4)MRP,  ");
            sb.Append("  IFNULL((cond.InititalCount-cond.ReleasedCount),0)BalanceQty,   ");
            sb.Append("  IFNULL(conr.ReturnQuantity,0)ReturnedQuantity,  ");
            sb.Append("  cond.DeptLedgerNo,cond.IsPost,cond.IsCancel,   ");
            sb.Append("  conr.ConsignmentReturnID,conr.ReturnDate,conr.ReturnReason   ");
            sb.Append("  FROM Consignmentdetail cond   ");
            sb.Append("  LEFT OUTER JOIN (SELECT ConsignmentID,SUM(ReturnQuantity)ReturnQuantity,ReturnDate,ReturnReason,ConsignmentReturnID,ConsignmentNo,ItemID  FROM consignmentreturn GROUP BY ConsignmentID   ) conr   ");
            sb.Append("  ON conr.ConsignmentID=cond.ID  WHERE cond.DeptLedgerNo= '" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' AND  cond.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");
            sb.Append("  )t1 WHERE BalanceQty >0 AND IsPost=1 AND IsCancel=0   ");
        if (ddlVendor.SelectedIndex > 0)
         sb.Append(" AND VendorLedgerNo = '" + ddlVendor.SelectedValue + "'");
        sb.Append("  AND IF(  MedExpiryDate='0001-01-31' ,1=1, DATE( MedExpiryDate)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'");
            sb.Append(" AND DATE( MedExpiryDate)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "')");
     sb.Append(" GROUP BY ID");
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            consignmentReturnSearch.DataSource = dt;
            consignmentReturnSearch.DataBind();
            lblMsg.Text = "";
            btnReturn.Visible = true;
        }

        else
        {
            lblMsg.Text = "No records found";
            btnReturn.Visible = false;
            consignmentReturnSearch.DataSource = "";
            consignmentReturnSearch.DataBind();
        }
    }


    protected void Return_Click(object sender,EventArgs e)
    {
        String strGatePassno = "";
        String strReason = "";
        String ID = "";
        String BatchNumber = "";
        String UnitPrice = "";
        String Rate = "";
        String MRP = "";
        String ItemID = "";
        String VendorLedgerNo = "";
        String sql = "";
        String txtReturnQuantity = "";
        string consignmentNO = "";
        string availQty = "";
        StringBuilder sb = new StringBuilder();

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string strSales = "select max(returnNo) from consignmentreturn ";
            int strreturnNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, strSales));
            strreturnNo += 1;

            int IsSaved = 0;

            for (int i = 0; i < consignmentReturnSearch.Rows.Count; i++)
            {
                if (((CheckBox)consignmentReturnSearch.Rows[i].FindControl("chkbxReturn")).Checked)
                {
                    availQty = Util.GetString(((Label)consignmentReturnSearch.Rows[i].FindControl("lblavalQty")).Text.ToString());
                    
                    strGatePassno = Util.GetString(((TextBox)consignmentReturnSearch.Rows[i].FindControl("txtPassno")).Text);
                    strReason = Util.GetString(((TextBox)consignmentReturnSearch.Rows[i].FindControl("txtReason")).Text);
                    BatchNumber = Util.GetString(((Label)consignmentReturnSearch.Rows[i].FindControl("lblBatchNumber")).Text);
                    consignmentNO = Util.GetString(((Label)consignmentReturnSearch.Rows[i].FindControl("lblconsnmntNO")).Text);
                    
                    Rate = Util.GetString(((Label)consignmentReturnSearch.Rows[i].FindControl("lblRate")).Text);
                    UnitPrice = Util.GetString(((Label)consignmentReturnSearch.Rows[i].FindControl("lblUnitPrice")).Text);
                    MRP = Util.GetString(((Label)consignmentReturnSearch.Rows[i].FindControl("lblMRP")).Text);
                    ItemID = Util.GetString(((Label)consignmentReturnSearch.Rows[i].FindControl("lblItemID")).Text);
                    VendorLedgerNo = Util.GetString(((Label)consignmentReturnSearch.Rows[i].FindControl("lblVendorLedgerNo")).Text);
                    txtReturnQuantity = Util.GetString(((TextBox)consignmentReturnSearch.Rows[i].FindControl("txtReturnQty")).Text);
                
                    if (Util.GetDecimal(txtReturnQuantity) > Util.GetDecimal(availQty))
                    {
                        lblMsg.Text = "Return Qty greater than Balance Qty !";
                        return;
                    }
                    if (txtReturnQuantity == "")
                    {
                        lblMsg.Text = "Please Enter Return QTY !";
                        return;
                    
                    }
                    ID = Util.GetString(((Label)consignmentReturnSearch.Rows[i].FindControl("lblID")).Text);

                    string strQuery = "INSERT INTO ConsignmentReturn(returnNo,ConsignmentNo,ConsignmentID,ReturnQuantity,BatchNo,Rate,UnitPrice,MRP,GatePassNo,ItemID,VendorLedgerNo,ReturnByUserID,ReturnDate,ReturnReason) VALUES(" + strreturnNo + "," + consignmentNO + "," + ID + ",'" + txtReturnQuantity + "','" + BatchNumber + "','" + Rate + "','" + UnitPrice + "','" + MRP + "','" + strGatePassno + "','" + ItemID + "','" + VendorLedgerNo + "','" + ViewState["EmpID"].ToString() + "',Now(),'" + strReason + "')";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                    strQuery = "UPDATE consignmentdetail SET ReleasedCount=ReleasedCount+" + txtReturnQuantity + " WHERE ID=" + ID + " and inititalcount -(ReleasedCount+" + txtReturnQuantity + ") >=0";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                    IsSaved = 1;
                }

            }

            if (IsSaved == 1)
            {
                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "funReturnNo(" + strreturnNo + ");", true);
                search();
            }
            else
                lblMsg.Text = "No Data Selected for Return..";
            return;

        }

        catch (Exception ex)
        {
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Record Not Saved !";
            return;

        }
   
    }

    public void ExportToExcel(string ID)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT*FROM consignmentdetail WHERE id IN(" + ID + ")");
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["CustomData"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
        }

    }

  
}
