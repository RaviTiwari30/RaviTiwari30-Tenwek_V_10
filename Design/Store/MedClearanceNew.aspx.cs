using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_MedClearanceNew : System.Web.UI.Page
{
    private string TID;

    protected void btnIsMedClear_Click(object sender, EventArgs e)
    {
        bool rowAffected;
        string view = "false";

        foreach (GridViewRow gr in grdIndentSearch.Rows)
        {
            if (((Label)gr.FindControl("lblView")).Text == "true")
            {
                view = "true";
            }
        }

        if ((bool)chkIsMedCleared.Checked)
        {
            if (view != "true")
            {
                string str = "UPDATE patient_medical_history SET IsMedCleared=1,MedClearedBy='" + ViewState["ID"].ToString() + "',MedClearedDate=now() WHERE TransactionID='" + Request.QueryString["TransactionID"].ToString() + "'";//f_ipdadjustment
                rowAffected = StockReports.ExecuteDML(str);
                if ((bool)rowAffected)
                {
                    string Msg = "Medicine Clearance Saved Successfully..";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
                else
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Error..";
                }
            }
            else
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Patient Medical Indents Are Pending..";
            }
        }
        else
        {
            if (view != "true")
            {
                string str = "UPDATE patient_medical_history SET IsMedCleared=0,MedClearedBy='" + ViewState["ID"].ToString() + "',MedClearedDate=now() WHERE TransactionID='" + Request.QueryString["TransactionID"].ToString() + "'";//f_ipdadjustment
                rowAffected = StockReports.ExecuteDML(str);
                if ((bool)rowAffected)
                {
                    string Msg = "Medicine Clearance Saved Successfully..";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
                else
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Error..";
                }
            }
            else
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Patient Medical Indents Are Pending..";
            }
        }
    }

    protected void btnRejectAll_Click(object sender, EventArgs e)
    {
        DataTable dt = (DataTable)ViewState["IndentDetail"];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            string indentno = dt.Rows[i]["IndentNo"].ToString();
            string itemId = dt.Rows[i]["ItemId"].ToString();
            string status = dt.Rows[i]["StatusNew"].ToString();
            if (status.ToUpper() == "OPEN")
            {
                StockReports.ExecuteDML("UPDATE f_indent_detail_patient SET RejectQty=ReqQty,RejectReason='To MedClearance',RejectBy='" + ViewState["ID"].ToString() + "',dtReject=CURDATE() WHERE IndentNo='" + indentno + "' AND ITemID='" + itemId + "'");
            }
            else if (status.ToUpper() == "PARTIAL")
            {
                StockReports.ExecuteDML("UPDATE f_indent_detail_patient SET RejectQty=(ReqQty-ReceiveQty),RejectReason='To MedClearance',RejectBy='" + ViewState["ID"].ToString() + "',dtReject=CURDATE() WHERE IndentNo='" + indentno + "' AND ITemID='" + itemId + "'");
            }
        }
        lblRejectMsg.Text = "Record Save";
        lblRejectMsg.Visible = true;
        btnRejectAll.Enabled = false;
        mpe2.Show();
    }

    protected void grdIndentdtl_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "REJECT")
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "CLOSE")
            {
                e.Row.BackColor = System.Drawing.Color.YellowGreen;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "OPEN")
            {
                e.Row.BackColor = System.Drawing.Color.LightBlue;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "PARTIAL")
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
            }
        }
    }

    protected void gvGRN_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblRejectMsg.Text = "";
        string IndentNo = "";
        if (e.CommandName == "AView")
        {
            IndentNo = Util.GetString(e.CommandArgument).Split('#')[0];

            string status = Util.GetString(e.CommandArgument).Split('#')[2];
            StringBuilder sb1 = new StringBuilder();
            sb1.Append("  SELECT (CASE WHEN id.reqQty=id.RejectQty THEN 'REJECT' WHEN  id.reqQty-id.ReceiveQty-id.RejectQty=0 THEN 'CLOSE' WHEN   id.reqQty+id.ReceiveQty+id.RejectQty=id.reqQty AND id.IsAutoReject!=1 THEN 'OPEN' WHEN (id.reqQty+id.ReceiveQty+id.RejectQty=id.reqQty OR id.reqQty-id.ReceiveQty-id.RejectQty>0) AND id.IsAutoReject=1 THEN 'AUTOREJECT' ELSE 'PARTIAL'  END)StatusNew,id.IndentNo,(rd.DeptName)DeptFrom,(rd1.DeptName)DeptTo,id.ItemId,id.ItemName,id.ReqQty,id.ReceiveQty,id.RejectQty,id.UnitType,id.Narration,  ");
            sb1.Append("  id.isApproved,   id.ApprovedBy,id.ApprovedReason,DATE_FORMAT(id.dtEntry,'%d-%b-%y')DATE,id.UserId,CONCAT(em.Title,' ',em.Name)EmpName, ");
            sb1.Append("   CONCAT(pm.Title,' ',pm.PName)PatientName,pmh.TransactionID,pmh.PatientID,(SELECT NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)DocName, ");
            sb1.Append("   fs.StockID,  sd.SoldUnits,sd.BillNo,sd.PerUnitBuyPrice,sd.PerUnitSellingPrice,fs.BatchNumber,fs.MRP,fs.MedExpiryDate, ");
            sb1.Append("   ROUND((FS.MRP*SD.SoldUnits),2)AMOUNT ");
            sb1.Append("   ,(id.ReqQty-id.ReceiveQty-id.RejectQty)PendingQty,(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE employeeID=id.rejectBy)RejectBy ");
            sb1.Append("  FROM ( ");
            sb1.Append("    SELECT * FROM f_indent_detail_patient id WHERE indentno='" + IndentNo + "' )id  INNER  JOIN f_rolemaster rd ON id.DeptFrom=rd.DeptLedgerNo   ");
            sb1.Append("   INNER JOIN f_rolemaster rd1  ON id.DeptTo=rd1.DeptLedgerNo  INNER JOIN employee_master em ON id.UserId=em.EmployeeID   ");
            sb1.Append("   INNER JOIN patient_medical_history pmh ON pmh.TransactionID=id.TransactionID  INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID   ");
            sb1.Append("   LEFT JOIN f_salesdetails sd ON id.IndentNo=sd.IndentNo AND id.ItemId=sd.ItemID  LEFT JOIN f_stock fs ON fs.StockID=sd.StockID   ");

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb1.ToString());
            if (dt.Rows.Count > 0)
            {
                grdIndentdtl.DataSource = dt;
                grdIndentdtl.DataBind();
                mpe2.Show();
                ViewState["IndentDetail"] = dt;
            }
            else
            {
                grdIndentdtl.DataSource = null;
                grdIndentdtl.DataBind();
                lblMsg.Text = "No Record Found";
            }

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string sts = dt.Rows[i]["StatusNew"].ToString();
                if (sts.ToUpper() == "OPEN" || sts.ToUpper() == "PARTIAL")
                {
                    btnRejectAll.Enabled = true;
                    return;
                }
            }

            btnRejectAll.Enabled = false;
        }
    }

    protected void gvGRN_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatusNew")).Text == "REJECT")
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "CLOSE")
            {
                e.Row.BackColor = System.Drawing.Color.YellowGreen;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "OPEN")
            {
                e.Row.BackColor = System.Drawing.Color.LightBlue;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "PARTIAL")
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            TID = Request.QueryString["TransactionID"].ToString();
			
	      string returnindent = "SELECT COUNT(*) FROM (SELECT * FROM f_indent_detail_patient_return WHERE reqQty+ReceiveQty+RejectQty=reqQty AND TransactionID='" + TID + "' GROUP BY IndentNo)t";            
		int Count = Util.GetInt(StockReports.ExecuteScalar(returnindent));
            if (Count > 0)
            {
                string Msg = "Medicine Return Indents are pending.";
                                lblMsg.Text=Msg;
           }
		 // DataTable pendingQty = StockReports.GetDataTable("SELECT SUM(f.ReqQty-(f.ReceiveQty+f.RejectQty))PendingQty FROM  f_indent_detail_patient_return f WHERE f.TransactionID='" + TID + "'  HAVING  PendingQty<>0");
         //  if (pendingQty.Rows.Count > 0)
         //   {
          //     Page.ClientScript.RegisterStartupScript(this.GetType(), "blockPage", "$(function () { onBlockUI(function(){});});", true);
         //   }
			
			

            // string IsDischarge = StockReports.ExecuteScalar("Select Status from ipd_case_history where TransactionID='" + TID + "'");
            DataTable dtIsMedClear = StockReports.GetDataTable("SELECT IFNULL(i.IsMedCleared,0)IsMedCleared,CONCAT(em.Title,'',em.Name)ClearedBy,DATE_FORMAT(i.MedClearedDate,'%d-%b-%Y %h:%i %p')MedClearedDate FROM patient_medical_history i LEFT JOIN employee_master em ON em.EmployeeID =i.MedClearedBy WHERE i.TransactionID='" + TID + "'");//f_ipdadjustment
            string IsBillFinal = StockReports.ExecuteScalar("Select BillNo from patient_medical_history where TransactionID='" + TID + "'");//f_ipdadjustment

            if (IsBillFinal == "")
            {
                if (Util.GetInt(dtIsMedClear.Rows[0]["IsMedCleared"]) != 1)
                {
                    chkIsMedCleared.Checked = false;
                    // CHECKING IF PERSON IS AUTHORISED TO GIVE CLEARANCE OF MEDICAL
                    int IsAuthorised = Util.GetInt(All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "IsMedClear"));
                    if (IsAuthorised == 0)
                    {
                        string Msg = "You Are Not Authorised for Medical Clearance...";
                        Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                    }
                    else
                    {
                        // Check for discharge process
                        string IsDisIntimated = "";
                        IsDisIntimated = StockReports.ExecuteScalar(" SELECT IsDisIntimated FROM patient_ipd_profile WHERE TransactionID='" + TID + "' AND IsDisIntimated=1 ORDER BY PatientIPDProfile_ID DESC LIMIT 1");
                        if (IsDisIntimated != "1")
                        {
                            lblMsg.Text = "Kindly Discharge Intimate First..";
                            chkIsMedCleared.Enabled = false;
                            btnIsMedClear.Enabled = false;
                        }
                    }
                }
                else
                {
                    chkIsMedCleared.Enabled = false;
                    btnIsMedClear.Enabled = false;
                }
            }
            else
            {
                chkIsMedCleared.Enabled = false;
                btnIsMedClear.Enabled = false;
                if (Util.GetInt(dtIsMedClear.Rows[0]["IsMedCleared"])== 1)
                    lblMsg.Text = "Pharmacy Clearence Already Done at " + dtIsMedClear.Rows[0]["MedClearedDate"].ToString() + " by " + dtIsMedClear.Rows[0]["ClearedBy"].ToString();
            }

            try
            {
                StringBuilder sb = new StringBuilder();

                sb.Append("SELECT *,IF(StatusNew='OPEN' OR StatusNew='PARTIAL','true','false')VIEW FROM (   ");
                sb.Append("SELECT t.*,(CASE WHEN  t.IsAutoReject=0 AND t.reqQty=t.RejectQty THEN 'REJECT'   ");
                sb.Append("WHEN t.IsAutoReject=0 AND t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'     ");
                sb.Append("WHEN   t.IsAutoReject=0 AND t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' WHEN t.IsAutoReject=1 THEN 'AUTOREJECT' ELSE 'PARTIAL'  END)StatusNew   ");
                sb.Append("FROM (             SELECT id.indentno,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,id.Status,SUM(id.IsAutoReject)IsAutoReject,  ");
                sb.Append("lm.ledgername AS DeptTo,   ");
                sb.Append(" REPLACE(pmh.TransactionID,'ISHHI','')TransactionID,   ");
                sb.Append(" SUM(id.ReqQty)ReqQty,  ");
                sb.Append("SUM(id.ReceiveQty)ReceiveQty,SUM(id.RejectQty)RejectQty FROM f_indent_detail_patient id   ");
                sb.Append("INNER JOIN (SELECT ledgername,ledgernumber FROM f_ledgermaster WHERE groupid='DPT')lm ON lm.LedgerNumber = id.deptto    ");
                sb.Append("INNER JOIN patient_medical_history pmh ON id.TransactionID=pmh.TransactionID      ");
                sb.Append(" WHERE id.StoreID = 'STO00001'   AND pmh.TransactionID = '" + TID + "'    ");
                sb.Append(" GROUP BY indentno ORDER BY id.indentno DESC  ");
                sb.Append("   ) t  ");
                sb.Append(" )t1  ");

                DataTable dtIndentDetails = StockReports.GetDataTable(sb.ToString());

                if (dtIndentDetails != null && dtIndentDetails.Rows.Count > 0)
                {
                    grdIndentSearch.DataSource = dtIndentDetails;
                    grdIndentSearch.DataBind();

                    float ReqQty = Util.GetFloat(dtIndentDetails.Compute("sum(ReqQty)", ""));
                    float ReceiveQty = Util.GetFloat(dtIndentDetails.Compute("sum(ReceiveQty)", ""));
                    float RejectQty = Util.GetFloat(dtIndentDetails.Compute("sum(RejectQty)", ""));

                    if (ReqQty == (ReceiveQty + RejectQty))
                        chkIsMedCleared.Checked = true;
                    else
                        chkIsMedCleared.Checked = false;
                }
                else
                {
                    grdIndentSearch.DataSource = null;
                    grdIndentSearch.DataBind();
                    return;
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error..";
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return;
            }
        }
    }
}