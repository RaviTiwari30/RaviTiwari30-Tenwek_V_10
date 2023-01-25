using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_PaymentConformation : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT LT.LedgerTransactionNo,rec.ReceiptNo,LT.TransactionID, ROUND(LT.NetAmount,2)Netamount,GrossAmount,ROUND(lt.Adjustment,2)Adjustment, ");
        sb.Append(" DATE_FORMAT(LT.Date,'%d-%b-%y')DATE,LT.TypeOfTnx,IF(lt.typeoftnx='Pharmacy-Issue',IF(pm.PatientID='CASH002',(SELECT NAME FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo),(SELECT Pname FROM patient_master WHERE PatientID=pm.PatientID)),IF(pm.PatientID='CASH002',(SELECT NAME FROM patient_general_master WHERE AgainstLedgerTnxNo=(SELECT AgainstLedgerTnxNo FROM f_salesdetails WHERE LedgerTransactionNo=lt.LedgerTransactionNo LIMIT 1)),(SELECT Pname FROM patient_master WHERE PatientID=pm.PatientID)))pname,PM.Age,CONCAT(IFNULL(PM.House_No,''),' ',IFNULL(PM.Street_Name,''),' ',IFNULL(PM.Locality,''),' ',IFNULL(PM.City,''))Address,  ");
        sb.Append(" '' CustomerID,pm.PatientID,LT.BillNo,lt.IsCancel FROM f_ledgertransaction LT ");
        sb.Append(" LEFT OUTER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo    and rec.IsCancel in (0,2)");
        sb.Append(" INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo INNER JOIN f_stock ST ON LTD.StockID=ST.StockID  ");
        sb.Append(" INNER JOIN patient_master PM ON LT.PatientID=PM.PatientID INNER JOIN patient_medical_history pmh  ");
        sb.Append(" ON lt.TransactionID = pmh.TransactionID WHERE LT.TypeOfTnx IN ('Pharmacy-Issue','Pharmacy-Return') ");
        sb.Append(" and DATE(lt.Date)>='" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
        if (ddlStatus.SelectedItem.Text == "Pending")
        {
            sb.Append(" AND lt.IsCancel= 2");
        }
        if (ddlStatus.SelectedItem.Text == "Confirmed")
        {
            sb.Append(" AND lt.IsCancel= 0");
        }
        if (ddlStatus.SelectedItem.Text == "All")
        {
            sb.Append(" AND lt.IsCancel IN(0,2)");
        }
        if (txtMRNo.Text.Trim() != string.Empty)
            sb.Append(" and PM.PatientID = '" + txtMRNo.Text.Trim() + "' ");

        sb.Append(" group by LT.LedgerTransactionNo");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdItem.DataSource = dt;
            grdItem.DataBind();
            lblMsg.Text = "";
        }
        else
        {
            grdItem.DataSource = dt;
            grdItem.DataBind();
            lblMsg.Text = "No Record Found";
            return;
        }
    }

    protected void grdItem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "AView")
        {
            string LedgerTnxNo = e.CommandArgument.ToString().Split('$')[0];
            string TypeOfTnx = e.CommandArgument.ToString().Split('$')[1];
            if (TypeOfTnx != "Pharmacy-Issue")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/PharmacyReturnReceipt.aspx?LedTnxNo=" + LedgerTnxNo + "&OutID=" + StockReports.ExecuteScalar("SELECT sd.PatientID FROM f_salesdetails sd INNER JOIN patient_general_master pgm ON pgm.`CustomerID`= sd.`PatientID` WHERE  sd.LedgerTransactionNo='" + LedgerTnxNo + "' ") + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/PharmacyReceipt.aspx?LedTnxNo=" + LedgerTnxNo + "&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + LedgerTnxNo + "' ") + "');", true);
            }
        }
        if (e.CommandName.ToString() == "Conform")
        {
            string LedTnxNo = e.CommandArgument.ToString();
            string OldUserID = StockReports.ExecuteScalar("SELECT UserID FROM f_ledgertransaction WHERE LedgerTransactionNo='" + LedTnxNo + "' ");
            bool Isupdate = StockReports.ExecuteDML("UPDATE f_ledgertransaction SET IsCancel=0,UserID='" + ViewState["UserID"].ToString() + "',EditUserID='" + ViewState["UserID"].ToString() + "',EditDateTime=NOW(),Cancel_UserID='" + OldUserID + "' WHERE LedgerTransactionNo='" + LedTnxNo + "' ");
            StockReports.ExecuteDML("UPDATE f_reciept SET IsCancel=0,reciever='" + ViewState["UserID"].ToString() + "',EditDateTime=NOW() WHERE AsainstLedgerTnxNo='" + LedTnxNo + "' ");

            if (Isupdate)
            {
                lblMsg.Text = "Payment Confirmed Successfully";
            }
            else
            {
                lblMsg.Text = "Error..";
                return;
            }
            btnSearch_Click(this, new EventArgs());
        }
    }

    protected void grdItem_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex > -1)
        {
            if (((Label)e.Row.FindControl("lblIsCancel")).Text == "0")
            {
                e.Row.BackColor = System.Drawing.Color.LightBlue;
                ((Button)e.Row.FindControl("btnConfirm")).Enabled = false;
            }
            else if (((Label)e.Row.FindControl("lblIsCancel")).Text == "2")
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["UserID"] = Session["ID"].ToString();
        }
        txtfromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
}