using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_Store_StoreInvoiceSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucDateFrom.SetCurrentDate();
            ucDateTo.SetCurrentDate();

            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            string TransactionID="";
            if (Request.QueryString["TransactionID"] != null)
            {
                TransactionID = Request.QueryString["TransactionID"].ToString();
            }
            else if (Request.QueryString["TID"] != null)
            {
                TransactionID = Request.QueryString["TID"].ToString();
            }
            txtTID.Text = TransactionID.Replace("ISHHI","");
        }
    }

    private void GetIssueDetails(string TransID)
    {
        StringBuilder sb = new StringBuilder();

        DataTable dt = new DataTable();
        if (dt.Rows.Count > 0)
        {
            float IssueAmount = Util.GetFloat(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'ISSUE DETAILS ::'"));
            float ReturnAmount = Util.GetFloat(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'RETURN DETAILS ::'"));

            DataColumn dc = new DataColumn();
            dc.ColumnName = "NetAmount";
            dc.DefaultValue = IssueAmount - ReturnAmount;

            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);
        }
        else
        {

            DataColumn dc = new DataColumn();
            dc.ColumnName = "NetAmount";
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "User";
            dt.Columns.Add(dc);

            DataRow dr = dt.NewRow();
            dr["User"] = Convert.ToString(Session["LoginName"]);
            dr["NetAmount"] = 0;
            dt.Rows.Add(dr);
        }

        StringBuilder psb = new StringBuilder();
        psb.Append("select ich.TransactionID,if(ich.DateOfAdmit = '0001-01-01',curdate(),ich.DateOfAdmit)DateOfAdmit,if(ich.DateOfDischarge = '0001-01-01',curdate(),ich.DateOfDischarge)DateOfDischarge,ich.Status,concat(pm.Title,' ',pm.PName)Name,pnl.Company_Name,");
        psb.Append(" concat(dm.Title,' ',dm.Name)Consultant from ipd_case_history ich inner join patient_medical_history pmh");
        psb.Append(" on ich.TransactionID = pmh.TransactionID inner join patient_master pm on pmh.PatientID = pm.PatientID");
        psb.Append(" inner join f_panel_master pnl on pmh.PanelID = pnl.PanelID inner join doctor_master dm on pmh.DoctorID = dm.DoctorID");
        psb.Append(" where ich.TransactionID = 'ISHHI" + TransID + "'");

        DataTable dtPatient = new DataTable();
        dtPatient = StockReports.GetDataTable(psb.ToString());

        DataSet ds = new DataSet();
        dtPatient.TableName = "PatientDetail";
        ds.Tables.Add(dtPatient.Copy());

        dt.TableName = "IssueDetails";
        ds.Tables.Add(dt.Copy());

        //ds.WriteXmlSchema(@"c:\AmitIssueMedical1111.xml");
        Session["ds"] = ds;
        Session["ReportName"] = "PatientIssueMedicalDetail";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);

    }

    private DataTable LoadData(string DeptLedgerNo, string status)
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            if (status == "All")
            {


                sb.Append("Select * from (");
                sb.Append("SELECT sd.`SalesID`,sd.`StockID`, '' tnxID,LT.TransactionID,sd.salesno,sd.IndentNo,sd.BillNo,ROUND(sd.PerUnitSellingPrice,2)MRP,sd.SoldUnits,");
                sb.Append("DATE_FORMAT(ltd.`EntryDate`,'%d-%b-%y')Date,ltd.ItemName,st.BatchNumber,");
                sb.Append("ROUND((sd.PerUnitSellingPrice*sd.SoldUnits),2)Amount,'ISSUE' TypeOfTnx,");
                sb.Append("DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,sd.LedgerTransactionNo,if(ltd.IsVerified=1,'Billed','NotBilled')BillStatus, ");
                sb.Append("(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=sd.DeptLedgerNo)Dept,sd.DeptLedgerNo,if(ifnull(sd.BillNo,'')<>'','true','false')IsInvoice ");
                sb.Append("FROM f_salesdetails sd INNER JOIN f_stock st ON sd.StockID = st.StockID ");
                sb.Append("INNER JOIN f_itemmaster im ON im.ItemID = st.ItemID ");
                sb.Append("INNER JOIN f_ledgertransaction LT ON sd.LedgerTransactionNo = LT.LedgerTransactionNo ");
                sb.Append("INNER JOIN f_ledgertnxdetail ltd ON Ltd.LedgerTransactionNo = LT.LedgerTransactionNo AND ltd.StockID = sd.StockID ");
                sb.Append("WHERE sd.TrasactionTypeID = 3  AND LT.IsCancel = 0 AND ltd.IsVerified <> 2 ");
                // sb.Append("AND sd.BillNo!='' ");

                if (ddlPackage.SelectedValue == "1")
                {
                }
                else if (ddlPackage.SelectedValue == "2")
                {
                    sb.Append("AND ltd.IsPackage='1' ");

                }
                else
                {
                    sb.Append("AND ltd.IsPackage='0' ");
                }





                if (txtBillNo.Text != "")
                    sb.Append(" AND sd.BillNo='" + txtBillNo.Text + "'");

                if (txtTID.Text.Trim() != "")
                    sb.Append(" AND LT.TransactionID = 'ISHHI" + txtTID.Text.Trim() + "' ");


                if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
                    sb.Append("AND sd.DeptLedgerNo='" + UserValidation(Session["LoginType"].ToString()) + "'");
                if (txtBillNo.Text == "" && txtTID.Text.Trim() == "")
                {
                    if (ucDateFrom.GetDateForDataBase() != string.Empty)
                        sb.Append(" AND DATE( ltd.`EntryDate`)>='" + ucDateFrom.GetDateForDataBase() + "'");
                    if (ucDateTo.GetDateForDataBase() != string.Empty)
                        sb.Append(" AND DATE( ltd.`EntryDate`)<='" + ucDateTo.GetDateForDataBase() + "'");
                }

                sb.Append("UNION ALL ");

                sb.Append("SELECT sd.`SalesID`,sd.`StockID`, ltd.LedgerTnxID tnxID,LT.TransactionID,REPLACE(lt.LedgerTransactionNo,'PRSHHI',''),sd.IndentNo,sd.BillNo,ROUND(sd.PerUnitSellingPrice,2)MRP,ltd.Quantity, ");
                sb.Append("DATE_FORMAT(lt.Date,'%d-%b-%y')DATE,ltd.ItemName,st.BatchNumber, ");
                sb.Append("ROUND((ltd.Quantity*ltd.Rate),2)Amount,'RETURN' AS TypeOfTnx, ");
                sb.Append("DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,sd.LedgerTransactionNo,if(ltd.IsVerified=1,'Billed','NotBilled')BillStatus, ");
                sb.Append("(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=sd.DeptLedgerNo)Dept,sd.DeptLedgerNo,if(ifnull(sd.BillNo,'')<>'','true','false')IsInvoice ");
                sb.Append("FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd  ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ");
                sb.Append("INNER JOIN f_stock st ON st.STOCKID = LTD.STOCKID INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ");
                sb.Append("INNER JOIN f_salesdetails sd ON sd.LedgerTransactionNo = lt.LedgerTransactionNo ");
                sb.Append("AND ltd.StockID = sd.StockID WHERE LT.TypeOfTnx = 'Patient-Return' AND LT.IsCancel = 0  AND ltd.IsVerified <> 2 ");
                //  sb.Append("AND sd.BillNo!='' ");

                if (ddlPackage.SelectedValue == "1")
                {
                }
                else if (ddlPackage.SelectedValue == "2")
                {
                    sb.Append("AND ltd.IsPackage='1' ");

                }
                else
                {
                    sb.Append("AND ltd.IsPackage='0' ");
                }
                if (txtBillNo.Text != "")
                    sb.Append(" AND sd.BillNo='" + txtBillNo.Text + "'");


                if (txtTID.Text.Trim() != "")
                    sb.Append(" AND LT.TransactionID = 'ISHHI" + txtTID.Text.Trim() + "' ");

                if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
                    sb.Append("AND sd.DeptLedgerNo='" + UserValidation(Session["LoginType"].ToString()) + "'");
                if (txtBillNo.Text == "" && txtTID.Text.Trim() == "")
                {
                    if (ucDateFrom.GetDateForDataBase() != string.Empty)
                        sb.Append(" AND DATE( ltd.`EntryDate`)>='" + ucDateFrom.GetDateForDataBase() + "'");
                    if (ucDateTo.GetDateForDataBase() != string.Empty)
                        sb.Append(" AND DATE( ltd.`EntryDate`)<='" + ucDateTo.GetDateForDataBase() + "'");
                }
                sb.Append(")t order by DATE,Dept,TypeOfTnx,BillNo");

            }

            else if (status == "Issue")
            {
                sb.Append("SELECT sd.`SalesID`,sd.`StockID`, '' tnxID,LT.TransactionID,sd.salesno,sd.IndentNo,sd.BillNo,ROUND(sd.PerUnitSellingPrice,2)MRP,sd.SoldUnits,");
                sb.Append("DATE_FORMAT(ltd.`EntryDate`,'%d-%b-%y')Date,ltd.ItemName,st.BatchNumber,");
                sb.Append("ROUND((sd.PerUnitSellingPrice*sd.SoldUnits),2)Amount,'ISSUE' TypeOfTnx,");
                sb.Append("DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,sd.LedgerTransactionNo,if(im.ToBeBilled=1,'Billed','NotBilled')BillStatus, ");
                sb.Append("(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=sd.DeptLedgerNo)Dept,sd.DeptLedgerNo,if(ifnull(sd.BillNo,'')<>'','true','false')IsInvoice ");
                sb.Append("FROM f_salesdetails sd INNER JOIN f_stock st ON sd.StockID = st.StockID ");
                sb.Append("INNER JOIN f_itemmaster im ON im.ItemID = st.ItemID ");
                sb.Append("INNER JOIN f_ledgertransaction LT ON sd.LedgerTransactionNo = LT.LedgerTransactionNo ");
                sb.Append("INNER JOIN f_ledgertnxdetail ltd ON Ltd.LedgerTransactionNo = LT.LedgerTransactionNo AND ltd.StockID = sd.StockID ");
                sb.Append("WHERE sd.TrasactionTypeID = 3  AND LT.IsCancel = 0 AND ltd.IsVerified <> 2 ");
                // sb.Append("AND sd.BillNo!='' ");

                if (ddlPackage.SelectedValue == "1")
                {
                }
                else if (ddlPackage.SelectedValue == "2")
                {
                    sb.Append("AND ltd.IsPackage='1' ");

                }
                else
                {
                    sb.Append("AND ltd.IsPackage='0' ");
                }
                if (txtBillNo.Text != "")
                    sb.Append(" AND sd.BillNo='" + txtBillNo.Text + "'");

                if (txtTID.Text.Trim() != "")
                    sb.Append(" AND LT.TransactionID = 'ISHHI" + txtTID.Text.Trim() + "' ");

                if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
                    sb.Append("AND sd.DeptLedgerNo='" + UserValidation(Session["LoginType"].ToString()) + "'");
                if (txtBillNo.Text == "" && txtTID.Text.Trim() == "")
                {
                    if (ucDateFrom.GetDateForDataBase() != string.Empty)
                        sb.Append(" AND DATE( ltd.`EntryDate`)>='" + ucDateFrom.GetDateForDataBase() + "'");
                    if (ucDateTo.GetDateForDataBase() != string.Empty)
                        sb.Append(" AND DATE( ltd.`EntryDate`)<='" + ucDateTo.GetDateForDataBase() + "'");

                }
                sb.Append("order by DATE,Dept,TypeOfTnx,BillNo");
            }

            else if (status == "Return")
            {
                sb.Append("SELECT sd.`SalesID`,sd.`StockID`, ltd.LedgerTnxID tnxID,LT.TransactionID,REPLACE(lt.LedgerTransactionNo,'PRSHHI',''),sd.IndentNo,sd.BillNo,ROUND(sd.PerUnitSellingPrice,2)MRP,ltd.Quantity SoldUnits, ");
                sb.Append("DATE_FORMAT(lt.Date,'%d-%b-%y')DATE,ltd.ItemName,st.BatchNumber, ");
                sb.Append("ROUND((ltd.Quantity*ltd.Rate),2)Amount,'RETURN' AS TypeOfTnx, ");
                sb.Append("DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,sd.LedgerTransactionNo,if(im.ToBeBilled=1,'Billed','NotBilled')BillStatus, ");
                sb.Append("(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=sd.DeptLedgerNo)Dept,sd.DeptLedgerNo,if(ifnull(sd.BillNo,'')<>'','true','false')IsInvoice ");
                sb.Append("FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd  ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ");
                sb.Append("INNER JOIN f_stock st ON st.STOCKID = LTD.STOCKID INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ");
                sb.Append("INNER JOIN f_salesdetails sd ON sd.LedgerTransactionNo = lt.LedgerTransactionNo ");
                sb.Append("AND ltd.StockID = sd.StockID WHERE LT.TypeOfTnx = 'Patient-Return' AND LT.IsCancel = 0  AND ltd.IsVerified <> 2 ");
                //sb.Append("AND sd.BillNo!='' ");

                if (ddlPackage.SelectedValue == "1")
                {
                }
                else if (ddlPackage.SelectedValue == "2")
                {
                    sb.Append("AND ltd.IsPackage='1' ");

                }
                else
                {
                    sb.Append("AND ltd.IsPackage='0' ");
                }
                if (txtBillNo.Text != "")
                    sb.Append(" AND sd.BillNo='" + txtBillNo.Text + "'");

                if (txtTID.Text.Trim() != "")
                    sb.Append(" AND LT.TransactionID = 'ISHHI" + txtTID.Text.Trim() + "' ");

                if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
                    sb.Append("AND sd.DeptLedgerNo='" + UserValidation(Session["LoginType"].ToString()) + "'");
                if (txtBillNo.Text == "" && txtTID.Text.Trim() == "")
                {
                    if (ucDateFrom.GetDateForDataBase() != string.Empty)
                        sb.Append(" AND DATE( ltd.`EntryDate`)>='" + ucDateFrom.GetDateForDataBase() + "'");
                    if (ucDateTo.GetDateForDataBase() != string.Empty)
                        sb.Append(" AND DATE( ltd.`EntryDate`)<='" + ucDateTo.GetDateForDataBase() + "'");
                }
                sb.Append(" GROUP BY DATE,`LedgerTransactionNo` ,stockid ");
                sb.Append("order by DATE,Dept,TypeOfTnx,BillNo");

            }
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn("BillAmount");
                dt.Columns.Add(dc);

                foreach (DataRow dr in dt.Rows)
                {
                    if (dr["BillNo"].ToString() != string.Empty)
                        dr["BillAmount"] = Util.GetFloat(dt.Compute("sum(Amount)", "BillNo='" + dr["BillNo"].ToString() + "'")).ToString("f2");
                }

                float IssueAmount = Util.GetFloat(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'ISSUE'"));
                float ReturnAmount = Util.GetFloat(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'RETURN'"));
                float BilledIssue = Util.GetFloat(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'ISSUE' AND BillStatus = 'Billed'")); ;
                float NotBilledIssue = Util.GetFloat(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'ISSUE' AND BillStatus = 'NotBilled'")); ;
                float NotBilledReturn = Util.GetFloat(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'RETURN' AND BillStatus='NotBilled'"));
                float BilledReturn = Util.GetFloat(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'RETURN' AND BillStatus='Billed'")); ;

                if (IssueAmount > 0)
                    lblIssue.Text = "Issue : " + IssueAmount.ToString() + "&nbsp;";
                else
                    lblIssue.Text = "";

                if (ReturnAmount > 0)
                    lblReturn.Text = "Return : " + ReturnAmount.ToString() + "&nbsp;";
                else
                    lblReturn.Text = "";

                if (BilledIssue > 0)
                    lblBilledIssue.Text = "BilledIssue : " + BilledIssue.ToString() + "&nbsp;";
                else
                    lblBilledIssue.Text = "";

                if (NotBilledIssue > 0)
                    lblNotBilledIssue.Text = "NotBilledIssue : " + NotBilledIssue.ToString() + "&nbsp;";
                else
                    lblNotBilledIssue.Text = "";

                if (NotBilledReturn > 0)
                    lblNotBilledReturn.Text = "NotBilledReturn : " + NotBilledReturn.ToString() + "&nbsp;";
                else
                    lblNotBilledReturn.Text = "";

                if (BilledReturn > 0)
                    lblBilledReturn.Text = "BilledReturn : " + BilledReturn.ToString();
                else
                    lblBilledReturn.Text = "";

                lblMsg.Text = "";
            }

            else
            {

                lblIssue.Text = "";
                lblReturn.Text = "";
                lblBilledIssue.Text = "";
                lblNotBilledIssue.Text = "";
                lblNotBilledReturn.Text = "";
                lblBilledReturn.Text = "";

            }


            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
            return null;
        }
    }

    private string UserValidation(string LoginType)
    {
        string Dept = "";
        switch (LoginType.ToUpper())
        {
            case "BILLING":
            case "ACCOUNTS":
            case "EDP":
            case "ADMIN":
                break;
            case "MRD":
            case "NURSING STATION":
            case "NURSING(CASUALITY)":
            case "NURSING(2ND FLOOR)":
            case "NURSING(ADMINISTRATOR)":
            case "ICU":
            case "OT":
            case "DELUXE":
            case "GENERAL":
            case "ECONOMY":
            case "DIALYSIS":
            case "LABOURROOM":
            case "NICU":
            case "SICU":
            case "OTRECOVERY":
            case "DAYCARE":
            case "LABORATORY":
            case "RADIOLOGY":
            case "NON INVASIVE CARDIAC LAB":
            case "NEUROLOGY LAB":
            case "GASTRO LAB":
            case "PULMONORY LAB":
            case "UROLOGY LAB":
            case "DIABETIC LAB":
            case "X-RAY":
            case "ULTRASOUND":
            case "CT SCAN":
                Dept = ViewState["DeptLedgerNo"].ToString();
                break;
        }

        return Dept;
    }

    protected void grdSearch_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string IndentNo = "";
        StringBuilder sb1 = new StringBuilder();
        DataTable dtGopal = new DataTable();
        DataTable dts = new DataTable();
        DataSet ds = new DataSet();

        if (e.CommandName == "AView")
        {
            IndentNo = Util.GetString(e.CommandArgument).Split('#')[0];


            sb1 = new StringBuilder();
            sb1.Append(" SELECT id.IndentNo,(rd.DeptName)DeptFrom,(rd1.DeptName)DeptTo,id.ItemName,id.ReqQty,id.ReceiveQty,id.RejectQty,id.UnitType,id.Narration,id.isApproved,  ");
            sb1.Append(" id.ApprovedBy,id.ApprovedReason,id.dtEntry,id.UserId,CONCAT(em.Title,' ',em.Name)EmpName,CONCAT(pm.Title,' ',pm.PName)PatientName,pmh.TransactionID,pmh.PatientID,(SELECT NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)DocName,fs.StockID, ");
            sb1.Append(" sd.SoldUnits,sd.BillNo,sd.PerUnitBuyPrice,sd.PerUnitSellingPrice,fs.BatchNumber,ROUND(sd.PerUnitSellingPrice,2)MRP,fs.MedExpiryDate,ROUND((ROUND(sd.PerUnitSellingPrice,2)*SD.SoldUnits),2)AMOUNT");
            sb1.Append(" FROM f_indent_detail_patient id ");
            sb1.Append(" INNER  JOIN f_rolemaster rd ON id.DeptFrom=rd.DeptLedgerNo ");
            sb1.Append(" INNER JOIN f_role_dept rd1  ON id.DeptTo=rd1.DeptLedgerNo ");
            sb1.Append(" INNER JOIN employee_master em ON id.UserId=em.Employee_ID ");
            sb1.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=id.TransactionID ");
            sb1.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
            sb1.Append(" INNER JOIN f_salesdetails sd ON id.IndentNo=sd.IndentNo AND id.ItemId=sd.ItemID ");
            sb1.Append(" INNER JOIN f_stock fs ON fs.StockID=sd.StockID ");
            sb1.Append(" WHERE id.indentno='" + IndentNo + "' ");

            dts = StockReports.GetDataTable(sb1.ToString());

            if (dts != null && dts.Rows.Count > 0)
            {
                ds = new DataSet();
                ds.Tables.Add(dts.Copy());
                Session["ds"] = ds;
                Session["ReportName"] = "PatientNewIndent";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Finanace/Commonreport.aspx');", true);
            }
        }
        else if (e.CommandName == "IView")
        {
            string chkinvoice = "";
            if (Chkin.Checked)
            {
                chkinvoice = "1";
            }
            else
            {
                chkinvoice = "0";
            }
            string argmnt = Util.GetString(e.CommandArgument).Split('#')[1];
            string BillNo = Util.GetString(e.CommandArgument).Split('#')[0];
            string TID = Util.GetString(e.CommandArgument).Split('#')[2];
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('InternalStockTransferPatientRecipt.aspx?bilno=" + BillNo + "&typeOftnx=" + argmnt + "&TID=" + TID + "&chkinvoice=" + chkinvoice + "');", true);

        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        searchBindGrid("All");
    }

    public void searchBindGrid(string status)
    {
        ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

        //if (Request.QueryString["TID"] != null)
        //    TID = Request.QueryString["TID"].ToString();
        //else if (Request.QueryString["TransactionID"] != null)
        //    TID = Request.QueryString["TransactionID"].ToString();
        DataTable dt = new DataTable();
        dt = LoadData(ViewState["DeptLedgerNo"].ToString(), status);
        if (dt != null && dt.Rows.Count > 0)
        {

            grdSearch.DataSource = dt;
            grdSearch.DataBind();
        }

        else
        {
            grdSearch.DataSource = null;
            grdSearch.DataBind();

            lblMsg.Text = "Records Not Found";
        }

    }

    protected void btnSummary_Click(object sender, EventArgs e)
    {
        string LoginType = string.Empty;
        string DateFrom = string.Empty;
        string DatTo = string.Empty;
        string TID = string.Empty;
        if (Request.QueryString["TID"] != null)
            TID = Request.QueryString["TID"].ToString();
        else if (Request.QueryString["TransactionID"] != null)
            TID = Request.QueryString["TransactionID"].ToString();
        if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
        {
            LoginType = UserValidation(Session["LoginType"].ToString());
        }

        if (ucDateFrom.GetDateForDataBase() != string.Empty)
        {
            DateFrom = ucDateFrom.GetDateForDataBase();
        }
        if (ucDateTo.GetDateForDataBase() != string.Empty)
        {
            DatTo = ucDateTo.GetDateForDataBase();
        }

        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('med_BillDetails_Summary.aspx?DateFrom=" + DateFrom + "&DateTo=" + DatTo + "&TID=" + TID + "&LoginType=" + LoginType + "');", true);

    }

    protected void ddlStts_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        if (ddlStts.SelectedItem.Value == "All")
        {
            searchBindGrid("All");
        }
        else if (ddlStts.SelectedItem.Value == "Issue")
        {
            searchBindGrid("Issue");

        }
        else if (ddlStts.SelectedItem.Value == "Return")
        {
            searchBindGrid("Return");
        }
    }

    protected void grdSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lbltype")).Text == "ISSUE")
            {
                // FOr Close
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#99FFCC");

                e.Row.ForeColor = System.Drawing.Color.Black;
                //((ImageButton)e.Row.FindControl("imbView")).Visible = false;
                //((ImageButton)e.Row.FindControl("imbReject")).Visible = false;

            }
            else if (((Label)e.Row.FindControl("lbltype")).Text == "RETURN")
            {
                // For Reject
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FF99CC");
                e.Row.ForeColor = System.Drawing.Color.Black;
                //((ImageButton)e.Row.FindControl("imbView")).Visible = false;
                //((ImageButton)e.Row.FindControl("imbReject")).Visible = false;
            }

        }
    }
    protected void btnPDF_Click(object sender, EventArgs e)
    {
        ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

        StringBuilder sb = new StringBuilder();

        if (ddlStts.SelectedValue.ToUpper() == "ALL")
        {
            sb.Append("SELECT t.*, pm.PName, ");
            sb.Append("(SELECT NAME FROM doctor_master WHERE DoctorID=ich.Consultant_ID)Doctor, ");
            sb.Append("(SELECT NAME FROM ipd_case_type_master WHERE ipdcasetype_ID=(SELECT ipdcasetype_ID FROM ");
            sb.Append("patient_ipd_profile WHERE TransactionID=t.TransactionID ORDER BY PatientIPDProfile_ID DESC LIMIT 1))Room ");
            sb.Append("FROM ( ");
            sb.Append("    SELECT  sd.`SalesID`,sd.`StockID`,'' tnxID,LT.PatientID,LT.TransactionID,sd.salesno,sd.IndentNo,sd.BillNo, ");
            sb.Append("    ROUND(sd.PerUnitSellingPrice,2)MRP,sd.SoldUnits,DATE_FORMAT(ltd.`EntryDate`,'%d-%b-%y')DATE,ltd.ItemName, ");
            sb.Append("    st.BatchNumber,ROUND((sd.PerUnitSellingPrice*sd.SoldUnits),2)Amount,st.SaleTaxPer, ");
            //  sb.Append("    st.BatchNumber,ROUND(((ltd.Quantity*ltd.rate)-((ltd.Quantity*ltd.rate)-ltd.amount)),2)Amount,st.SaleTaxPer, ");          
            sb.Append("    ((sd.PerUnitSellingPrice*sd.SoldUnits)-(((sd.PerUnitSellingPrice*sd.SoldUnits)*100)/(st.saleTaxPer+100)))Tax, ");
            sb.Append("    'ISSUE' TypeOfTnx,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,sd.LedgerTransactionNo, ");
            sb.Append("   IF(ltd.IsVerified=1,'Billed','NotBilled')BillStatus, ");
            sb.Append("    IF(IFNULL(sd.BillNo,'')<>'','true','false')IsInvoice,mm.NAME Manufacture ");
            sb.Append("    FROM f_salesdetails sd INNER JOIN f_stock st ON sd.StockID = st.StockID ");
            sb.Append("    INNER JOIN f_itemmaster im ON im.ItemID = st.ItemID ");
            sb.Append("    INNER JOIN f_ledgertransaction LT ON sd.LedgerTransactionNo = LT.LedgerTransactionNo ");
            //sb.Append("    INNER JOIN f_ledgertnxdetail ltd ON Ltd.LedgerTransactionNo = LT.LedgerTransactionNo AND ltd.StockID = sd.StockID ");
            sb.Append("    INNER JOIN f_ledgertnxdetail ltd ON Ltd.`LedgerTransactionNo` = sd.`LedgerTransactionNo` AND sd.`StockID`=ltd.`StockID`      ");
            sb.Append("    LEFT OUTER JOIN f_manufacture_master mm ON mm.MAnufactureID=im.ManufactureID ");
            //  sb.Append("    WHERE sd.TrasactionTypeID = 3  AND LT.IsCancel = 0 AND ltd.IsVerified =1 AND sd.BillNo!='' ");
            sb.Append("    WHERE sd.TrasactionTypeID = 3  AND LT.IsCancel = 0 AND ltd.IsVerified =1  ");

            if (ddlPackage.SelectedValue == "1")
            {
            }
            else if (ddlPackage.SelectedValue == "2")
            {
                sb.Append("AND ltd.IsPackage='1' ");

            }
            else
            {
                sb.Append("AND ltd.IsPackage='0' ");
            }
            if (txtBillNo.Text != "")


                sb.Append(" AND sd.BillNo='" + txtBillNo.Text + "'");

            if (txtTID.Text.Trim() != "")
                sb.Append(" AND LT.TransactionID = 'ISHHI" + txtTID.Text.Trim() + "' ");

            if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
                sb.Append("AND sd.DeptLedgerNo='" + UserValidation(Session["LoginType"].ToString()) + "'");
          //  if (txtBillNo.Text == "" && txtTID.Text.Trim() == "")
          //  {
               // if (ucDateFrom.GetDateForDataBase() != string.Empty)
               //     sb.Append(" AND DATE( ltd.`EntryDate`)>='" + ucDateFrom.GetDateForDataBase() + "'");
               // if (ucDateTo.GetDateForDataBase() != string.Empty)
               //     sb.Append(" AND DATE( ltd.`EntryDate`)<='" + ucDateTo.GetDateForDataBase() + "'");
           // }
            sb.Append("    UNION ALL ");
            sb.Append("    SELECT sd.`SalesID`,sd.`StockID`,ltd.LedgerTnxID tnxID,LT.PatientID,LT.TransactionID, ");
            sb.Append("    REPLACE(lt.LedgerTransactionNo,'PRSHHI',''),sd.IndentNo,sd.BillNo,ROUND(sd.PerUnitSellingPrice,2)MRP,ltd.Quantity, ");
            sb.Append("    DATE_FORMAT(lt.Date,'%d-%b-%y')DATE,ltd.ItemName,st.BatchNumber, ");
            //sb.Append("    ROUND((ltd.Quantity*St.MRP),2)Amount,st.SaleTaxPer, ");
            sb.Append("    ROUND((ltd.rate*ltd.quantity),2)Amount,st.SaleTaxPer, ");
            sb.Append("    ((sd.PerUnitSellingPrice*sd.SoldUnits)-(((sd.PerUnitSellingPrice*sd.SoldUnits)*100)/(st.saleTaxPer+100)))Tax, ");
            sb.Append("    'RETURN' AS TypeOfTnx,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,sd.LedgerTransactionNo, ");
            sb.Append("    IF(ltd.IsVerified=1,'Billed','NotBilled')BillStatus, ");
            sb.Append("    IF(IFNULL(sd.BillNo,'')<>'','true','false')IsInvoice,mm.NAME Manufacture ");
            sb.Append("    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd  ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ");
            sb.Append("    INNER JOIN f_stock st ON st.STOCKID = LTD.STOCKID ");
            sb.Append("    INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ");
            sb.Append("    INNER JOIN f_salesdetails sd ON Ltd.`LedgerTransactionNo` = sd.`LedgerTransactionNo` AND sd.`StockID`=ltd.`StockID`      ");
            sb.Append("    LEFT OUTER JOIN f_manufacture_master mm ON mm.MAnufactureID=im.ManufactureID ");
            //  sb.Append("    WHERE LT.TypeOfTnx = 'Patient-Return' AND LT.IsCancel = 0  AND ltd.IsVerified =1 AND sd.BillNo!='' ");
            sb.Append("    WHERE LT.TypeOfTnx = 'Patient-Return' AND LT.IsCancel = 0  AND ltd.IsVerified =1 ");
            if (ddlPackage.SelectedValue == "1")
            {
            }
            else if (ddlPackage.SelectedValue == "2")
            {
                sb.Append("AND ltd.IsPackage='1' ");

            }
            else
            {
                sb.Append("AND ltd.IsPackage='0' ");
            }

            if (txtBillNo.Text != "")


                sb.Append(" AND sd.BillNo='" + txtBillNo.Text + "'");

            if (txtTID.Text.Trim() != "")
                sb.Append(" AND LT.TransactionID = 'ISHHI" + txtTID.Text.Trim() + "' ");

            if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
                sb.Append("AND sd.DeptLedgerNo='" + UserValidation(Session["LoginType"].ToString()) + "'");
           // if (txtBillNo.Text == "" && txtTID.Text.Trim() == "")
          //  {
           //     if (ucDateFrom.GetDateForDataBase() != string.Empty)
           //         sb.Append(" AND DATE( ltd.`EntryDate`)>='" + ucDateFrom.GetDateForDataBase() + "'");
           //     if (ucDateTo.GetDateForDataBase() != string.Empty)
           //         sb.Append(" AND DATE( ltd.`EntryDate`)<='" + ucDateTo.GetDateForDataBase() + "'");
          //  }
            sb.Append(")t INNER JOIN IPD_Case_History ich ON t.TransactionID = ich.TransactionID ");
            sb.Append("INNER JOIN Patient_master pm ON pm.PatientID = t.PatientID ");
            sb.Append(" GROUP BY DATE,`LedgerTransactionNo` ,stockid ");
            sb.Append("ORDER BY DATE,TypeOfTnx,BillNo ");
        }
        else if (ddlStts.SelectedValue.ToUpper() == "RETURN")
        {
            sb.Append("SELECT t.*, pm.PName, ");
            sb.Append("(SELECT NAME FROM doctor_master WHERE DoctorID=ich.Consultant_ID)Doctor, ");
            sb.Append("(SELECT NAME FROM ipd_case_type_master WHERE ipdcasetype_ID=(SELECT ipdcasetype_ID FROM ");
            sb.Append("patient_ipd_profile WHERE TransactionID=t.TransactionID ORDER BY PatientIPDProfile_ID DESC LIMIT 1))Room ");
            sb.Append("FROM ( ");
            sb.Append("    SELECT sd.`SalesID`,sd.`StockID`,ltd.LedgerTnxID tnxID,LT.PatientID,LT.TransactionID, ");
            sb.Append("    REPLACE(lt.LedgerTransactionNo,'PRSHHI',''),sd.IndentNo,sd.BillNo,ROUND(sd.PerUnitSellingPrice,2)MRP,ltd.Quantity, ");
            sb.Append("    DATE_FORMAT(lt.Date,'%d-%b-%y')DATE,ltd.ItemName,st.BatchNumber, ");
            //sb.Append("    ROUND((ltd.Quantity*St.MRP),2)Amount,st.SaleTaxPer, ");
            sb.Append("    ROUND((ltd.Quantity*ltd.rate),2)Amount,st.SaleTaxPer, ");

            sb.Append("    ((sd.PerUnitSellingPrice*sd.SoldUnits)-(((sd.PerUnitSellingPrice*sd.SoldUnits)*100)/(st.saleTaxPer+100)))Tax, ");
            sb.Append("    'RETURN' AS TypeOfTnx,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,sd.LedgerTransactionNo, ");
            sb.Append("    IF(ltd.IsVerified=1,'Billed','NotBilled')BillStatus, ");
            sb.Append("    IF(IFNULL(sd.BillNo,'')<>'','true','false')IsInvoice,mm.NAME Manufacture ");
            sb.Append("    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd  ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ");
            sb.Append("    INNER JOIN f_stock st ON st.STOCKID = LTD.STOCKID ");
            sb.Append("    INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ");
            sb.Append("    INNER JOIN f_salesdetails sd ON Ltd.`LedgerTransactionNo` = sd.`LedgerTransactionNo` AND sd.`StockID`=ltd.`StockID`     ");
            sb.Append("    LEFT OUTER JOIN f_manufacture_master mm ON mm.MAnufactureID=im.ManufactureID ");
            // sb.Append("    WHERE LT.TypeOfTnx = 'Patient-Return' AND LT.IsCancel = 0  AND ltd.IsVerified <> 2 AND sd.BillNo!='' ");
            sb.Append("    WHERE LT.TypeOfTnx = 'Patient-Return' AND LT.IsCancel = 0  AND ltd.IsVerified = 1  ");

            if (ddlPackage.SelectedValue == "1")
            {
            }
            else if (ddlPackage.SelectedValue == "2")
            {
                sb.Append("AND ltd.IsPackage='1' ");

            }
            else
            {
                sb.Append("AND ltd.IsPackage='0' ");
            }
            if (txtBillNo.Text != "")
                sb.Append(" AND sd.BillNo='" + txtBillNo.Text + "'");

            if (txtTID.Text.Trim() != "")
                sb.Append(" AND LT.TransactionID = 'ISHHI" + txtTID.Text.Trim() + "' ");

            if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
                sb.Append("AND sd.DeptLedgerNo='" + UserValidation(Session["LoginType"].ToString()) + "'");
            if (txtBillNo.Text == "" && txtTID.Text.Trim() == "")
            {
                if (ucDateFrom.GetDateForDataBase() != string.Empty)
                    sb.Append(" AND DATE( ltd.`EntryDate`)>='" + ucDateFrom.GetDateForDataBase() + "'");
                if (ucDateTo.GetDateForDataBase() != string.Empty)
                    sb.Append(" AND DATE( ltd.`EntryDate`)<='" + ucDateTo.GetDateForDataBase() + "'");
            }
            sb.Append(")t INNER JOIN IPD_Case_History ich ON t.TransactionID = ich.TransactionID ");
            sb.Append("INNER JOIN Patient_master pm ON pm.PatientID = t.PatientID ");
            sb.Append(" GROUP BY DATE,`LedgerTransactionNo` ,stockid ");
            sb.Append("ORDER BY DATE,TypeOfTnx,BillNo ");
        }
        else if (ddlStts.SelectedValue.ToUpper() == "ISSUE")
        {
            sb.Append("SELECT t.*, pm.PName, ");
            sb.Append("(SELECT NAME FROM doctor_master WHERE DoctorID=ich.Consultant_ID)Doctor, ");
            sb.Append("(SELECT NAME FROM ipd_case_type_master WHERE ipdcasetype_ID=(SELECT ipdcasetype_ID FROM ");
            sb.Append("patient_ipd_profile WHERE TransactionID=t.TransactionID ORDER BY PatientIPDProfile_ID DESC LIMIT 1))Room ");
            sb.Append("FROM ( ");
            sb.Append("    SELECT sd.`SalesID`,sd.`StockID`,'' tnxID,LT.PatientID,LT.TransactionID,sd.salesno,sd.IndentNo,sd.BillNo, ");
            sb.Append("    ROUND(sd.PerUnitSellingPrice,2)MRP,sd.SoldUnits,DATE_FORMAT(ltd.`EntryDate`,'%d-%b-%y')DATE,ltd.ItemName, ");
            sb.Append("    st.BatchNumber,ROUND((sd.PerUnitSellingPrice*sd.SoldUnits),2)Amount,st.SaleTaxPer, ");
            sb.Append("    ((sd.PerUnitSellingPrice*sd.SoldUnits)-(((sd.PerUnitSellingPrice*sd.SoldUnits)*100)/(st.saleTaxPer+100)))Tax, ");
            sb.Append("    'ISSUE' TypeOfTnx,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,sd.LedgerTransactionNo, ");
            sb.Append("   IF(ltd.IsVerified=1,'Billed','NotBilled')BillStatus, ");
            sb.Append("    IF(IFNULL(sd.BillNo,'')<>'','true','false')IsInvoice,mm.NAME Manufacture ");
            sb.Append("    FROM f_salesdetails sd INNER JOIN f_stock st ON sd.StockID = st.StockID ");
            sb.Append("    INNER JOIN f_itemmaster im ON im.ItemID = st.ItemID ");
            sb.Append("    INNER JOIN f_ledgertransaction LT ON sd.LedgerTransactionNo = LT.LedgerTransactionNo ");
            sb.Append("    INNER JOIN f_ledgertnxdetail ltd ON Ltd.`LedgerTransactionNo` = sd.`LedgerTransactionNo` AND sd.`StockID`=ltd.`StockID`      ");
            sb.Append("    LEFT OUTER JOIN f_manufacture_master mm ON mm.MAnufactureID=im.ManufactureID ");
            //sb.Append("    WHERE sd.TrasactionTypeID = 3  AND LT.IsCancel = 0 AND ltd.IsVerified <> 2 AND sd.BillNo!='' ");
            sb.Append("    WHERE sd.TrasactionTypeID = 3  AND LT.IsCancel = 0 AND ltd.IsVerified <> 2 ");

            if (ddlPackage.SelectedValue == "1")
            {
            }
            else if (ddlPackage.SelectedValue == "2")
            {
                sb.Append("AND ltd.IsPackage='1' ");

            }
            else
            {
                sb.Append("AND ltd.IsPackage='0' ");
            }
            if (txtBillNo.Text != "")
                sb.Append(" AND sd.BillNo='" + txtBillNo.Text + "'");

            if (txtTID.Text.Trim() != "")
                sb.Append(" AND LT.TransactionID = 'ISHHI" + txtTID.Text.Trim() + "' ");

            if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
                sb.Append("AND sd.DeptLedgerNo='" + UserValidation(Session["LoginType"].ToString()) + "'");

            if (txtBillNo.Text == "" && txtTID.Text.Trim() == "")
            {
                if (ucDateFrom.GetDateForDataBase() != string.Empty)
                    sb.Append(" AND DATE( ltd.`EntryDate`)>='" + ucDateFrom.GetDateForDataBase() + "'");
                if (ucDateTo.GetDateForDataBase() != string.Empty)
                    sb.Append(" AND DATE( ltd.`EntryDate`)<='" + ucDateTo.GetDateForDataBase() + "'");
            }

            sb.Append(")t INNER JOIN IPD_Case_History ich ON t.TransactionID = ich.TransactionID ");
            sb.Append("INNER JOIN Patient_master pm ON pm.PatientID = t.PatientID ");
            sb.Append(" GROUP BY DATE,`LedgerTransactionNo` ,stockid ");
            sb.Append("ORDER BY DATE,TypeOfTnx,BillNo ");
        }



        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn col = new DataColumn();
            col.ColumnName = "Package";

            if (ddlPackage.SelectedValue == "1")
            {
                col.DefaultValue = "";
            }
            else if (ddlPackage.SelectedValue == "2")
            {
                col.DefaultValue = "Package ";
            }
            else
            {
                col.DefaultValue = " Non Package";
            }
            dt.Columns.Add(col);
            dt.AcceptChanges();
        }
        if (dt != null && dt.Rows.Count > 0)
        {
            //dt.WriteXmlSchema("c:/AnandPDF.xml");

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            // ds.WriteXmlSchema(@"c:\DischargeWithoutBill.xml");
            Session["ReportName"] = "PatientIssueReturnSummary";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/Commonreport.aspx');", true);

        }

        else
        {
            lblMsg.Text = "Records Not Found";
        }
    }

    protected void btnBillRegister_Click(object sender, EventArgs e)
    {
        ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

        StringBuilder sb = new StringBuilder();

        if (ddlStts.SelectedValue.ToUpper() == "ALL")
        {
            sb.Append("SELECT t.DATE,t.BillNo,TypeOfTnx,pm.PName,Concat(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City,' ',IF(pm.Pincode=0 OR pm.Pincode='','',pm.Pincode))Patient_Address, ");
            sb.Append("(SELECT NAME FROM doctor_master WHERE DoctorID=ich.Consultant_ID)Prescribed_By, ");
            sb.Append("(SELECT TRIM(CONCAT(House_No,' ',Street_Name,' ',Locality,' ',State,' ',City,' ',StateRegion,' ',CountryRegion,' '))FROM doctor_master WHERE DoctorID=ich.Consultant_ID)Prescriber_Address, ");
            sb.Append(" ItemName,BatchNumber,Manufacture,ExpiryDate,SoldUnits Quantity,MRP,Amount ");
            sb.Append("FROM ( ");
            sb.Append("    SELECT '' tnxID,LT.PatientID,LT.TransactionID,sd.salesno,sd.IndentNo,sd.BillNo, ");
            sb.Append("    ROUND(sd.PerUnitSellingPrice,2)MRP,sd.SoldUnits,DATE_FORMAT(ltd.`EntryDate`,'%d-%b-%y')DATE,ltd.ItemName, ");
            sb.Append("    st.BatchNumber,ROUND((sd.PerUnitSellingPrice*sd.SoldUnits),2)Amount,st.SaleTaxPer, ");
            sb.Append("    ((sd.PerUnitSellingPrice*sd.SoldUnits)-(((sd.PerUnitSellingPrice*sd.SoldUnits)*100)/(st.saleTaxPer+100)))Tax, ");
            sb.Append("    'ISSUE' TypeOfTnx,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,sd.LedgerTransactionNo, ");
            sb.Append("   IF(ltd.IsVerified=1,'Billed','NotBilled')BillStatus, ");
            sb.Append("    IF(IFNULL(sd.BillNo,'')<>'','true','false')IsInvoice,mm.NAME Manufacture ");
            sb.Append("    FROM f_salesdetails sd INNER JOIN f_stock st ON sd.StockID = st.StockID ");
            sb.Append("    INNER JOIN f_itemmaster im ON im.ItemID = st.ItemID ");
            sb.Append("    INNER JOIN f_ledgertransaction LT ON sd.LedgerTransactionNo = LT.LedgerTransactionNo ");
            sb.Append("    INNER JOIN f_ledgertnxdetail ltd ON Ltd.LedgerTransactionNo = LT.LedgerTransactionNo AND ltd.StockID = sd.StockID ");
            sb.Append("    LEFT OUTER JOIN f_manufacture_master mm ON mm.MAnufactureID=im.ManufactureID ");
            //  sb.Append("    WHERE sd.TrasactionTypeID = 3  AND LT.IsCancel = 0 AND ltd.IsVerified <> 2 AND sd.BillNo!='' ");
            sb.Append("    WHERE sd.TrasactionTypeID = 3  AND LT.IsCancel = 0 AND ltd.IsVerified <> 2  ");

            if (ddlPackage.SelectedValue == "1")
            {
            }
            else if (ddlPackage.SelectedValue == "2")
            {
                sb.Append("AND ltd.IsPackage='1' ");

            }
            else
            {
                sb.Append("AND ltd.IsPackage='0' ");
            }
            if (txtBillNo.Text != "")
                sb.Append(" AND sd.BillNo='" + txtBillNo.Text + "'");

            if (txtTID.Text.Trim() != "")
                sb.Append(" AND LT.TransactionID = 'ISHHI" + txtTID.Text.Trim() + "' ");

            if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
                sb.Append("AND sd.DeptLedgerNo='" + UserValidation(Session["LoginType"].ToString()) + "'");
            if (txtBillNo.Text == "" && txtTID.Text.Trim() == "")
            {
                if (ucDateFrom.GetDateForDataBase() != string.Empty)
                    sb.Append(" AND DATE( ltd.`EntryDate`)>='" + ucDateFrom.GetDateForDataBase() + "'");
                if (ucDateTo.GetDateForDataBase() != string.Empty)
                    sb.Append(" AND DATE( ltd.`EntryDate`)<='" + ucDateTo.GetDateForDataBase() + "'");
            }
            sb.Append("    UNION ALL ");
            sb.Append("    SELECT ltd.LedgerTnxID tnxID,LT.PatientID,LT.TransactionID, ");
            sb.Append("    REPLACE(lt.LedgerTransactionNo,'PRSHHI',''),sd.IndentNo,sd.BillNo,ROUND(sd.PerUnitSellingPrice,2)MRP,ltd.Quantity, ");
            sb.Append("    DATE_FORMAT(lt.Date,'%d-%b-%y')DATE,ltd.ItemName,st.BatchNumber, ");
            sb.Append("    ROUND((ltd.Quantity*ltd.Rate),2)Amount,st.SaleTaxPer, ");
            sb.Append("    ((sd.PerUnitSellingPrice*sd.SoldUnits)-(((sd.PerUnitSellingPrice*sd.SoldUnits)*100)/(st.saleTaxPer+100)))Tax, ");
            sb.Append("    'RETURN' AS TypeOfTnx,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,sd.LedgerTransactionNo, ");
            sb.Append("    IF(ltd.IsVerified=1,'Billed','NotBilled')BillStatus, ");
            sb.Append("    IF(IFNULL(sd.BillNo,'')<>'','true','false')IsInvoice,mm.NAME Manufacture ");
            sb.Append("    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd  ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ");
            sb.Append("    INNER JOIN f_stock st ON st.STOCKID = LTD.STOCKID ");
            sb.Append("    INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ");
            sb.Append("    INNER JOIN f_salesdetails sd ON sd.LedgerTransactionNo = lt.LedgerTransactionNo AND ltd.StockID = sd.StockID ");
            sb.Append("    LEFT OUTER JOIN f_manufacture_master mm ON mm.MAnufactureID=im.ManufactureID ");
            //sb.Append("    WHERE LT.TypeOfTnx = 'Patient-Return' AND LT.IsCancel = 0  AND ltd.IsVerified <> 2 AND sd.BillNo!='' ");
            sb.Append("    WHERE LT.TypeOfTnx = 'Patient-Return' AND LT.IsCancel = 0  AND ltd.IsVerified <> 2  ");

            if (ddlPackage.SelectedValue == "1")
            {
            }
            else if (ddlPackage.SelectedValue == "2")
            {
                sb.Append("AND ltd.IsPackage='1' ");

            }
            else
            {
                sb.Append("AND ltd.IsPackage='0' ");
            }
            if (txtBillNo.Text != "")
                sb.Append(" AND sd.BillNo='" + txtBillNo.Text + "'");

            if (txtTID.Text.Trim() != "")
                sb.Append(" AND LT.TransactionID = 'ISHHI" + txtTID.Text.Trim() + "' ");

            if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
                sb.Append("AND sd.DeptLedgerNo='" + UserValidation(Session["LoginType"].ToString()) + "'");
            if (txtBillNo.Text == "" && txtTID.Text.Trim() == "")
            {
                if (ucDateFrom.GetDateForDataBase() != string.Empty)
                    sb.Append(" AND DATE( ltd.`EntryDate`)>='" + ucDateFrom.GetDateForDataBase() + "'");
                if (ucDateTo.GetDateForDataBase() != string.Empty)
                    sb.Append(" AND DATE( ltd.`EntryDate`)<='" + ucDateTo.GetDateForDataBase() + "'");
            }
            sb.Append(")t INNER JOIN IPD_Case_History ich ON t.TransactionID = ich.TransactionID ");
            sb.Append("INNER JOIN Patient_master pm ON pm.PatientID = t.PatientID ");
            sb.Append(" GROUP BY DATE,`LedgerTransactionNo` ,stockid ");
            sb.Append("ORDER BY DATE,TypeOfTnx,BillNo ");
        }
        else if (ddlStts.SelectedValue.ToUpper() == "RETURN")
        {
            sb.Append("SELECT t.DATE,t.BillNo,TypeOfTnx,pm.PName,Concat(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City,' ',IF(pm.Pincode=0 OR pm.Pincode='','',pm.Pincode))Patient_Address, ");
            sb.Append("(SELECT NAME FROM doctor_master WHERE DoctorID=ich.Consultant_ID)Prescribed_By, ");
            sb.Append("(SELECT TRIM(CONCAT(House_No,' ',Street_Name,' ',Locality,' ',State,' ',City,' ',StateRegion,' ',CountryRegion,' '))FROM doctor_master WHERE DoctorID=ich.Consultant_ID)Prescriber_Address, ");
            sb.Append(" ItemName,BatchNumber,Manufacture,ExpiryDate,SoldUnits Quantity,MRP,Amount ");
            sb.Append("FROM ( ");
            sb.Append("    SELECT ltd.LedgerTnxID tnxID,LT.PatientID,LT.TransactionID, ");
            sb.Append("    REPLACE(lt.LedgerTransactionNo,'PRSHHI',''),sd.IndentNo,sd.BillNo,sd.PerUnitSellingPrice MRP,ltd.Quantity, ");
            sb.Append("    DATE_FORMAT(lt.Date,'%d-%b-%y')DATE,ltd.ItemName,st.BatchNumber, ");
            sb.Append("    ROUND((ltd.Quantity*ltd.Rate),2)Amount,st.SaleTaxPer, ");
            sb.Append("    ((sd.PerUnitSellingPrice*sd.SoldUnits)-(((sd.PerUnitSellingPrice*sd.SoldUnits)*100)/(st.saleTaxPer+100)))Tax, ");
            sb.Append("    'RETURN' AS TypeOfTnx,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,sd.LedgerTransactionNo, ");
            sb.Append("    IF(ltd.IsVerified=1,'Billed','NotBilled')BillStatus, ");
            sb.Append("    IF(IFNULL(sd.BillNo,'')<>'','true','false')IsInvoice,mm.NAME Manufacture ");
            sb.Append("    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd  ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ");
            sb.Append("    INNER JOIN f_stock st ON st.STOCKID = LTD.STOCKID ");
            sb.Append("    INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ");
            sb.Append("    INNER JOIN f_salesdetails sd ON sd.LedgerTransactionNo = lt.LedgerTransactionNo AND ltd.StockID = sd.StockID ");
            sb.Append("    LEFT OUTER JOIN f_manufacture_master mm ON mm.MAnufactureID=im.ManufactureID ");
            //   sb.Append("    WHERE LT.TypeOfTnx = 'Patient-Return' AND LT.IsCancel = 0  AND ltd.IsVerified <> 2 AND sd.BillNo!='' ");
            sb.Append("    WHERE LT.TypeOfTnx = 'Patient-Return' AND LT.IsCancel = 0  AND ltd.IsVerified <> 2  ");

            if (ddlPackage.SelectedValue == "1")
            {
            }
            else if (ddlPackage.SelectedValue == "2")
            {
                sb.Append("AND ltd.IsPackage='1' ");

            }
            else
            {
                sb.Append("AND ltd.IsPackage='0' ");
            }
            if (txtBillNo.Text != "")
                sb.Append(" AND sd.BillNo='" + txtBillNo.Text + "'");

            if (txtTID.Text.Trim() != "")
                sb.Append(" AND LT.TransactionID = 'ISHHI" + txtTID.Text.Trim() + "' ");

            if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
                sb.Append("AND sd.DeptLedgerNo='" + UserValidation(Session["LoginType"].ToString()) + "'");
            if (txtBillNo.Text == "" && txtTID.Text.Trim() == "")
            {
                if (ucDateFrom.GetDateForDataBase() != string.Empty)
                    sb.Append(" AND DATE( ltd.`EntryDate`)>='" + ucDateFrom.GetDateForDataBase() + "'");
                if (ucDateTo.GetDateForDataBase() != string.Empty)
                    sb.Append(" AND DATE( ltd.`EntryDate`)<='" + ucDateTo.GetDateForDataBase() + "'");
            }
            sb.Append(")t INNER JOIN IPD_Case_History ich ON t.TransactionID = ich.TransactionID ");
            sb.Append("INNER JOIN Patient_master pm ON pm.PatientID = t.PatientID ");
            sb.Append(" GROUP BY DATE,`LedgerTransactionNo` ,stockid ");
            sb.Append("ORDER BY DATE,TypeOfTnx,BillNo ");
        }
        else if (ddlStts.SelectedValue.ToUpper() == "ISSUE")
        {
            sb.Append("SELECT t.DATE,t.BillNo,TypeOfTnx,pm.PName,Concat(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City,' ',IF(pm.Pincode=0 OR pm.Pincode='','',pm.Pincode))Patient_Address, ");
            sb.Append("(SELECT NAME FROM doctor_master WHERE DoctorID=ich.Consultant_ID)Prescribed_By, ");
            sb.Append("(SELECT TRIM(CONCAT(House_No,' ',Street_Name,' ',Locality,' ',State,' ',City,' ',StateRegion,' ',CountryRegion,' '))FROM doctor_master WHERE DoctorID=ich.Consultant_ID)Prescriber_Address, ");
            sb.Append(" ItemName,BatchNumber,Manufacture,ExpiryDate,SoldUnits Quantity,MRP,Amount ");
            sb.Append("FROM ( ");
            sb.Append("    SELECT '' tnxID,LT.PatientID,LT.TransactionID,sd.salesno,sd.IndentNo,sd.BillNo, ");
            sb.Append("    ROUND(sd.PerUnitSellingPrice,2)MRP,sd.SoldUnits,DATE_FORMAT(ltd.`EntryDate`,'%d-%b-%y')DATE,ltd.ItemName, ");
            sb.Append("    st.BatchNumber,ROUND((sd.PerUnitSellingPrice*sd.SoldUnits),2)Amount,st.SaleTaxPer, ");
            sb.Append("    ((sd.PerUnitSellingPrice*sd.SoldUnits)-(((sd.PerUnitSellingPrice*sd.SoldUnits)*100)/(st.saleTaxPer+100)))Tax, ");
            sb.Append("    'ISSUE' TypeOfTnx,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,sd.LedgerTransactionNo, ");
            sb.Append("    IF(ltd.IsVerified=1,'Billed','NotBilled')BillStatus, ");
            sb.Append("    IF(IFNULL(sd.BillNo,'')<>'','true','false')IsInvoice,mm.NAME Manufacture ");
            sb.Append("    FROM f_salesdetails sd INNER JOIN f_stock st ON sd.StockID = st.StockID ");
            sb.Append("    INNER JOIN f_itemmaster im ON im.ItemID = st.ItemID ");
            sb.Append("    INNER JOIN f_ledgertransaction LT ON sd.LedgerTransactionNo = LT.LedgerTransactionNo ");
            sb.Append("    INNER JOIN f_ledgertnxdetail ltd ON Ltd.LedgerTransactionNo = LT.LedgerTransactionNo AND ltd.StockID = sd.StockID ");
            sb.Append("    LEFT OUTER JOIN f_manufacture_master mm ON mm.MAnufactureID=im.ManufactureID ");
            //sb.Append("    WHERE sd.TrasactionTypeID = 3  AND LT.IsCancel = 0 AND ltd.IsVerified <> 2 AND sd.BillNo!='' ");
            sb.Append("    WHERE sd.TrasactionTypeID = 3  AND LT.IsCancel = 0 AND ltd.IsVerified <> 2 ");

            if (ddlPackage.SelectedValue == "1")
            {
            }
            else if (ddlPackage.SelectedValue == "2")
            {
                sb.Append("AND ltd.IsPackage='1' ");

            }
            else
            {
                sb.Append("AND ltd.IsPackage='0' ");
            }
            if (txtBillNo.Text != "")
                sb.Append(" AND sd.BillNo='" + txtBillNo.Text + "'");

            if (txtTID.Text.Trim() != "")
                sb.Append(" AND LT.TransactionID = 'ISHHI" + txtTID.Text.Trim() + "' ");

            if (UserValidation(Session["LoginType"].ToString()) != string.Empty)
                sb.Append("AND sd.DeptLedgerNo='" + UserValidation(Session["LoginType"].ToString()) + "'");

            if (txtBillNo.Text == "" && txtTID.Text.Trim() == "")
            {
                if (ucDateFrom.GetDateForDataBase() != string.Empty)
                    sb.Append(" AND DATE( ltd.`EntryDate`)>='" + ucDateFrom.GetDateForDataBase() + "'");
                if (ucDateTo.GetDateForDataBase() != string.Empty)
                    sb.Append(" AND DATE( ltd.`EntryDate`)<='" + ucDateTo.GetDateForDataBase() + "'");
            }

            sb.Append(")t INNER JOIN IPD_Case_History ich ON t.TransactionID = ich.TransactionID ");
            sb.Append("INNER JOIN Patient_master pm ON pm.PatientID = t.PatientID ");
            sb.Append("ORDER BY DATE,TypeOfTnx,BillNo ");
        }



        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Pharmacy Bill Register";
            Session["Period"] = "From : " + ucDateFrom.GetDateForDisplay() + " To : " + ucDateTo.GetDateForDisplay();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Finanace/ExportToExcel.aspx');", true);
        }

        else
        {
            lblMsg.Text = "Records Not Found";
        }
    }
}